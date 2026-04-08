import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Quiz Question Model

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let choices: [String]
    let correctIndex: Int
    let category: QuizCategory
    let explanation: String
}

enum QuizCategory: String, CaseIterable {
    case checklists = "Checklists"
    case emergency = "Emergency"
    case approaches = "Approaches"
    case systems = "Systems"
    case limitations = "Limitations"

    var icon: String {
        switch self {
        case .checklists: return "checklist"
        case .emergency: return "exclamationmark.triangle.fill"
        case .approaches: return "scope"
        case .systems: return "gearshape.2"
        case .limitations: return "speedometer"
        }
    }

    var color: Color {
        switch self {
        case .checklists: return .cyan
        case .emergency: return .red
        case .approaches: return .green
        case .systems: return .indigo
        case .limitations: return .orange
        }
    }
}

// MARK: - Quiz Generator

struct QuizGenerator {
    static func generateQuestions(count: Int = 20, categories: Set<QuizCategory>? = nil) -> [QuizQuestion] {
        var allQuestions: [QuizQuestion] = []

        // Checklist questions
        allQuestions.append(contentsOf: checklistQuestions())

        // Emergency questions
        allQuestions.append(contentsOf: emergencyQuestions())

        // Approach questions
        allQuestions.append(contentsOf: approachQuestions())

        // Systems questions
        allQuestions.append(contentsOf: systemsQuestions())

        // Limitations questions
        allQuestions.append(contentsOf: limitationsQuestions())

        // Filter by category if specified
        if let categories = categories {
            allQuestions = allQuestions.filter { categories.contains($0.category) }
        }

        return Array(allQuestions.shuffled().prefix(count))
    }

    private static func checklistQuestions() -> [QuizQuestion] {
        var questions: [QuizQuestion] = []

        // Generate from checklist challenge/response pairs
        let checklists = A320Database.normalChecklists
        for checklist in checklists {
            for item in checklist.items {
                let correctResponse = item.response
                let wrongAnswers = generateWrongAnswers(correct: correctResponse, from: checklists.flatMap(\.items).map(\.response))
                if wrongAnswers.count >= 3 {
                    let choices = ([correctResponse] + wrongAnswers.prefix(3)).shuffled()
                    let correctIdx = choices.firstIndex(of: correctResponse) ?? 0
                    questions.append(QuizQuestion(
                        question: "During \(checklist.title), what is the correct response for \"\(item.challenge)\"?",
                        choices: choices,
                        correctIndex: correctIdx,
                        category: .checklists,
                        explanation: item.notes ?? "Standard \(checklist.title) procedure item."
                    ))
                }
            }
        }

        return questions
    }

    private static func emergencyQuestions() -> [QuizQuestion] {
        var questions: [QuizQuestion] = []

        let procedures = A320Database.emergencyProcedures
        for proc in procedures {
            // Memory items questions
            if !proc.memoryItems.isEmpty {
                let allMemoryItems = procedures.flatMap(\.memoryItems)
                for item in proc.memoryItems {
                    let wrong = allMemoryItems.filter { $0 != item }.shuffled().prefix(3)
                    if wrong.count >= 3 {
                        let choices = ([item] + wrong).shuffled()
                        let correctIdx = choices.firstIndex(of: item) ?? 0
                        questions.append(QuizQuestion(
                            question: "Which is a MEMORY ITEM for \"\(proc.title)\"?",
                            choices: choices,
                            correctIndex: correctIdx,
                            category: .emergency,
                            explanation: "Memory items must be performed from recall without reference to the checklist."
                        ))
                    }
                }
            }

            // Severity questions
            let wrongSeverities = EmergencySeverity.allCases.filter { $0 != proc.severity }
            if !wrongSeverities.isEmpty {
                let allChoices = ([proc.severity.rawValue] + wrongSeverities.map(\.rawValue)).shuffled()
                let correctIdx = allChoices.firstIndex(of: proc.severity.rawValue) ?? 0
                questions.append(QuizQuestion(
                    question: "What is the severity level of \"\(proc.title)\"?",
                    choices: allChoices,
                    correctIndex: correctIdx,
                    category: .emergency,
                    explanation: "\(proc.title) is classified as \(proc.severity.rawValue)."
                ))
            }
        }

        return questions
    }

    private static func approachQuestions() -> [QuizQuestion] {
        var questions: [QuizQuestion] = []
        let approaches = A320Database.approachProcedures

        for approach in approaches {
            // Minimums questions
            let wrongMinimums = approaches.filter { $0.id != approach.id }.map(\.minimums).shuffled().prefix(3)
            if wrongMinimums.count >= 3 {
                let choices = ([approach.minimums] + wrongMinimums).shuffled()
                let correctIdx = choices.firstIndex(of: approach.minimums) ?? 0
                questions.append(QuizQuestion(
                    question: "What are the minimums for a \(approach.name)?",
                    choices: choices,
                    correctIndex: correctIdx,
                    category: .approaches,
                    explanation: approach.description
                ))
            }

            // Required equipment
            if let firstEquip = approach.requiredEquipment.first {
                let allEquipment = Set(approaches.flatMap(\.requiredEquipment))
                let wrongEquip = allEquipment.filter { !approach.requiredEquipment.contains($0) }.shuffled().prefix(3)
                if wrongEquip.count >= 3 {
                    let choices = ([firstEquip] + wrongEquip).shuffled()
                    let correctIdx = choices.firstIndex(of: firstEquip) ?? 0
                    questions.append(QuizQuestion(
                        question: "Which equipment is required for a \(approach.name)?",
                        choices: choices,
                        correctIndex: correctIdx,
                        category: .approaches,
                        explanation: "Required equipment: \(approach.requiredEquipment.joined(separator: ", "))"
                    ))
                }
            }
        }

        return questions
    }

    private static func systemsQuestions() -> [QuizQuestion] {
        [
            QuizQuestion(
                question: "How many hydraulic systems does the A320 have?",
                choices: ["2 (Left, Right)", "3 (Green, Blue, Yellow)", "4 (A, B, C, D)", "2 (Primary, Secondary)"],
                correctIndex: 1, category: .systems,
                explanation: "The A320 has three independent hydraulic systems: Green, Blue, and Yellow."
            ),
            QuizQuestion(
                question: "What powers the Blue hydraulic system in an emergency?",
                choices: ["APU", "RAT (Ram Air Turbine)", "Battery", "Crossfeed from Green"],
                correctIndex: 1, category: .systems,
                explanation: "The RAT auto-deploys and powers the Blue hydraulic system and emergency generator."
            ),
            QuizQuestion(
                question: "What is the A320 normal hydraulic operating pressure?",
                choices: ["1,500 psi", "2,000 psi", "3,000 psi", "5,000 psi"],
                correctIndex: 2, category: .systems,
                explanation: "All three hydraulic systems operate at 3,000 psi."
            ),
            QuizQuestion(
                question: "How many flight control computers does the A320 have?",
                choices: ["3 (1 ELAC + 1 SEC + 1 FAC)", "5 (2 ELAC + 2 SEC + 1 FAC)", "7 (2 ELAC + 3 SEC + 2 FAC)", "4 (2 ELAC + 2 SEC)"],
                correctIndex: 2, category: .systems,
                explanation: "The A320 has 7 flight control computers: 2 ELAC, 3 SEC, and 2 FAC."
            ),
            QuizQuestion(
                question: "What is the correct flight control law degradation sequence?",
                choices: [
                    "Normal → Direct → Mechanical",
                    "Normal → Alternate → Direct → Mechanical",
                    "Normal → Backup → Emergency",
                    "Normal → Degraded → Manual"
                ],
                correctIndex: 1, category: .systems,
                explanation: "Control law degrades: Normal → Alternate → Direct → Mechanical backup (pitch trim + rudder only)."
            ),
            QuizQuestion(
                question: "What does the PTU connect?",
                choices: ["Green and Blue systems", "Blue and Yellow systems", "Green and Yellow systems", "All three systems"],
                correctIndex: 2, category: .systems,
                explanation: "The Power Transfer Unit provides cross-connection between Green and Yellow hydraulic systems."
            ),
            QuizQuestion(
                question: "How many AC generators does the A320 have (including APU)?",
                choices: ["2", "3", "4", "5"],
                correctIndex: 1, category: .systems,
                explanation: "Two IDGs (one per engine, 90 kVA each) plus one APU generator (90 kVA)."
            ),
            QuizQuestion(
                question: "What is the emergency battery endurance?",
                choices: ["~10 minutes", "~30 minutes", "~60 minutes", "~120 minutes"],
                correctIndex: 1, category: .systems,
                explanation: "Two 25Ah batteries provide approximately 30 minutes on the hot battery bus."
            ),
            QuizQuestion(
                question: "Which engine drives the Green hydraulic system?",
                choices: ["Engine 1", "Engine 2", "Either engine", "APU"],
                correctIndex: 0, category: .systems,
                explanation: "The Green system is powered by an Engine-Driven Pump (EDP) on Engine 1."
            ),
            QuizQuestion(
                question: "What are the bleed air sources for air conditioning?",
                choices: [
                    "Engines only",
                    "Engines and APU",
                    "Engine 1, Engine 2, APU, External",
                    "Engines and RAT"
                ],
                correctIndex: 2, category: .systems,
                explanation: "Bleed air can come from Engine 1, Engine 2, APU, or external pneumatic source."
            ),
            QuizQuestion(
                question: "What does ELAC stand for?",
                choices: [
                    "Electronic Landing Approach Computer",
                    "Elevator/Aileron Computer",
                    "Engine Logic And Control",
                    "Emergency Lateral Axis Computer"
                ],
                correctIndex: 1, category: .systems,
                explanation: "ELAC = Elevator/Aileron Computer. It handles normal law and autopilot commands."
            ),
            QuizQuestion(
                question: "What does FAC stand for?",
                choices: [
                    "Flight Augmentation Computer",
                    "Full Authority Controller",
                    "Flight Automation Computer",
                    "Fly-by-wire Actuator Controller"
                ],
                correctIndex: 0, category: .systems,
                explanation: "FAC = Flight Augmentation Computer. It handles yaw damper, rudder trim, and windshear detection."
            ),
        ]
    }

    private static func limitationsQuestions() -> [QuizQuestion] {
        [
            QuizQuestion(
                question: "What is the A320 MMO (Maximum Mach Operating)?",
                choices: ["M 0.78", "M 0.80", "M 0.82", "M 0.84"],
                correctIndex: 2, category: .limitations,
                explanation: "MMO for the A320 is Mach 0.82."
            ),
            QuizQuestion(
                question: "What is the maximum cabin differential pressure?",
                choices: ["6.00 psi", "7.50 psi", "8.06 psi", "9.00 psi"],
                correctIndex: 2, category: .limitations,
                explanation: "Maximum differential pressure is 8.06 psi."
            ),
            QuizQuestion(
                question: "What is the typical cabin altitude at FL350?",
                choices: ["~4,000 ft", "~5,500 ft", "~6,900 ft", "~8,000 ft"],
                correctIndex: 2, category: .limitations,
                explanation: "At FL350, cabin altitude is approximately 6,900 feet."
            ),
            QuizQuestion(
                question: "What is the A320 MTOW (Maximum Takeoff Weight)?",
                choices: ["64,500 kg", "73,500 kg", "78,000 kg", "85,000 kg"],
                correctIndex: 2, category: .limitations,
                explanation: "A320-200 MTOW is 78,000 kg (some variants differ slightly)."
            ),
            QuizQuestion(
                question: "What is the total usable fuel capacity by weight?",
                choices: ["~12,000 kg", "~15,500 kg", "~18,730 kg", "~23,000 kg"],
                correctIndex: 2, category: .limitations,
                explanation: "Total usable fuel is approximately 18,730 kg (19,010 liters at 0.785 kg/L)."
            ),
            QuizQuestion(
                question: "What is the typical VREF at MLW in CONF FULL?",
                choices: ["~121 KIAS", "~131 KIAS", "~141 KIAS", "~151 KIAS"],
                correctIndex: 1, category: .limitations,
                explanation: "VREF at maximum landing weight in CONF FULL is approximately 131 KIAS."
            ),
            QuizQuestion(
                question: "What is the standard ILS glideslope angle?",
                choices: ["2.5°", "3.0°", "3.5°", "4.0°"],
                correctIndex: 1, category: .limitations,
                explanation: "Standard ILS glideslope is 3.0 degrees."
            ),
            QuizQuestion(
                question: "What is the approximate one-engine-inoperative ceiling at MTOW?",
                choices: ["~10,000 ft", "~15,000 ft", "~20,000 ft", "~25,000 ft"],
                correctIndex: 2, category: .limitations,
                explanation: "OEI ceiling at MTOW is approximately 20,000 ft (ISA conditions)."
            ),
            QuizQuestion(
                question: "What thrust lever detents exist on the A320?",
                choices: [
                    "TOGA, MCT, CL, IDLE",
                    "TOGA, FLX/MCT, CL, IDLE, REV",
                    "TOGA, CLIMB, CRUISE, IDLE",
                    "MAX, FLEX, CLIMB, IDLE, REV"
                ],
                correctIndex: 1, category: .limitations,
                explanation: "Thrust lever detents: TOGA, FLX/MCT, CL (Climb), IDLE, and REV (Reverse)."
            ),
            QuizQuestion(
                question: "What is the approximate ADIRS alignment time?",
                choices: ["~2 min", "~5 min", "~7 min", "~10 min"],
                correctIndex: 2, category: .limitations,
                explanation: "Full NAV alignment of the ADIRS takes approximately 7 minutes."
            ),
        ]
    }

    private static func generateWrongAnswers(correct: String, from pool: [String]) -> [String] {
        let unique = Array(Set(pool.filter { $0 != correct }))
        return Array(unique.shuffled().prefix(3))
    }
}

// Make EmergencySeverity CaseIterable for quiz generation
extension EmergencySeverity: CaseIterable {
    static var allCases: [EmergencySeverity] { [.warning, .caution, .advisory] }
}

// MARK: - Quiz View

struct QuizView: View {
    @State private var questions: [QuizQuestion] = []
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int?
    @State private var showExplanation = false
    @State private var score = 0
    @State private var quizComplete = false
    @State private var selectedCategories: Set<QuizCategory> = Set(QuizCategory.allCases)
    @State private var questionCount = 10
    @State private var showSetup = true
    @State private var streak = 0
    @State private var bestStreak = 0
    @AppStorage("quizHighScore") private var highScore = 0
    @AppStorage("quizTotalAnswered") private var totalAnswered = 0
    @AppStorage("quizTotalCorrect") private var totalCorrect = 0

    #if os(iOS)
    private let hapticSuccess = UINotificationFeedbackGenerator()
    private let hapticError = UINotificationFeedbackGenerator()
    #endif

    var body: some View {
        NavigationStack {
            if showSetup {
                quizSetupView
            } else if quizComplete {
                quizResultsView
            } else if !questions.isEmpty {
                quizQuestionView
            }
        }
    }

    // MARK: - Setup View

    private var quizSetupView: some View {
        List {
            // Stats section
            Section("Your Stats") {
                HStack {
                    Label("Total Answered", systemImage: "number.circle")
                    Spacer()
                    Text("\(totalAnswered)")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Label("Accuracy", systemImage: "target")
                    Spacer()
                    Text(totalAnswered > 0 ? "\(Int(Double(totalCorrect) / Double(totalAnswered) * 100))%" : "—")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Label("High Score", systemImage: "trophy.fill")
                        .foregroundStyle(.yellow)
                    Spacer()
                    Text("\(highScore)/\(questionCount)")
                        .foregroundStyle(.yellow)
                }
            }

            // Category selection
            Section("Categories") {
                ForEach(QuizCategory.allCases, id: \.self) { category in
                    Button {
                        if selectedCategories.contains(category) {
                            if selectedCategories.count > 1 {
                                selectedCategories.remove(category)
                            }
                        } else {
                            selectedCategories.insert(category)
                        }
                    } label: {
                        HStack {
                            Image(systemName: category.icon)
                                .foregroundStyle(category.color)
                                .frame(width: 30)
                            Text(category.rawValue)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedCategories.contains(category) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(category.color)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            // Question count
            Section("Questions") {
                Picker("Number of Questions", selection: $questionCount) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("15").tag(15)
                    Text("20").tag(20)
                }
                .pickerStyle(.segmented)
            }

            // Start button
            Section {
                Button {
                    startQuiz()
                } label: {
                    HStack {
                        Spacer()
                        Label("Start Quiz", systemImage: "play.fill")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.cyan.opacity(0.2))
            }
        }
        .navigationTitle("Quiz Mode")
    }

    // MARK: - Question View

    private var quizQuestionView: some View {
        let question = questions[currentIndex]

        return ScrollView {
            VStack(spacing: 20) {
                // Progress bar
                VStack(spacing: 8) {
                    HStack {
                        Text("Question \(currentIndex + 1) of \(questions.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(streak > 0 ? .orange : .secondary)
                            Text("\(streak)")
                                .foregroundStyle(streak > 0 ? .orange : .secondary)
                        }
                        .font(.subheadline)
                    }

                    ProgressView(value: Double(currentIndex), total: Double(questions.count))
                        .tint(.cyan)
                }
                .padding(.horizontal)

                // Score
                HStack(spacing: 20) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("\(score)")
                            .font(.headline)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                        Text("\(currentIndex - score + (selectedAnswer != nil ? 0 : 0))")
                            .font(.headline)
                    }
                }

                // Category badge
                HStack {
                    Image(systemName: question.category.icon)
                    Text(question.category.rawValue)
                }
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(question.category.color.opacity(0.2))
                .foregroundStyle(question.category.color)
                .clipShape(Capsule())

                // Question
                Text(question.question)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Answer choices
                VStack(spacing: 12) {
                    ForEach(question.choices.indices, id: \.self) { index in
                        Button {
                            if selectedAnswer == nil {
                                selectAnswer(index)
                            }
                        } label: {
                            HStack {
                                Text(["A", "B", "C", "D"][index])
                                    .font(.headline.monospaced())
                                    .frame(width: 30)
                                Text(question.choices[index])
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if let selected = selectedAnswer {
                                    if index == question.correctIndex {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    } else if index == selected && selected != question.correctIndex {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            .padding()
                            .background(answerBackground(for: index, question: question))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(answerBorder(for: index, question: question), lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(selectedAnswer != nil)
                    }
                }
                .padding(.horizontal)

                // Explanation
                if showExplanation {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Explanation", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundStyle(.yellow)
                        Text(question.explanation)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))

                    // Next button
                    Button {
                        nextQuestion()
                    } label: {
                        HStack {
                            Spacer()
                            Text(currentIndex < questions.count - 1 ? "Next Question" : "See Results")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                            Spacer()
                        }
                        .padding()
                        .background(Color.cyan.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Results View

    private var quizResultsView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Score circle
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 12)
                        .frame(width: 150, height: 150)
                    Circle()
                        .trim(from: 0, to: Double(score) / Double(questions.count))
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    VStack {
                        Text("\(score)/\(questions.count)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                        Text("\(Int(Double(score) / Double(questions.count) * 100))%")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 20)

                // Grade
                Text(gradeMessage)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                // Stats
                VStack(spacing: 12) {
                    statRow(icon: "checkmark.circle.fill", color: .green, label: "Correct", value: "\(score)")
                    statRow(icon: "xmark.circle.fill", color: .red, label: "Incorrect", value: "\(questions.count - score)")
                    statRow(icon: "flame.fill", color: .orange, label: "Best Streak", value: "\(bestStreak)")
                    if score > highScore {
                        statRow(icon: "trophy.fill", color: .yellow, label: "New High Score!", value: "\(score)")
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        startQuiz()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Try Again", systemImage: "arrow.counterclockwise")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color.cyan.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showSetup = true
                        quizComplete = false
                    } label: {
                        HStack {
                            Spacer()
                            Label("Change Settings", systemImage: "gear")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Results")
    }

    // MARK: - Helper Views

    private func statRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 30)
            Text(label)
            Spacer()
            Text(value)
                .font(.headline)
        }
    }

    private func answerBackground(for index: Int, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer else {
            return Color.secondary.opacity(0.1)
        }
        if index == question.correctIndex {
            return Color.green.opacity(0.2)
        }
        if index == selected {
            return Color.red.opacity(0.2)
        }
        return Color.secondary.opacity(0.05)
    }

    private func answerBorder(for index: Int, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer else {
            return Color.secondary.opacity(0.2)
        }
        if index == question.correctIndex {
            return .green
        }
        if index == selected {
            return .red
        }
        return Color.clear
    }

    private var scoreColor: Color {
        let pct = Double(score) / Double(max(questions.count, 1))
        if pct >= 0.8 { return .green }
        if pct >= 0.6 { return .yellow }
        return .red
    }

    private var gradeMessage: String {
        let pct = Double(score) / Double(max(questions.count, 1))
        if pct >= 0.9 { return "Outstanding! Type Rating Ready" }
        if pct >= 0.8 { return "Great Job! Almost There" }
        if pct >= 0.6 { return "Good Effort, Keep Studying" }
        if pct >= 0.4 { return "More Study Needed" }
        return "Review the Material and Try Again"
    }

    // MARK: - Actions

    private func startQuiz() {
        questions = QuizGenerator.generateQuestions(count: questionCount, categories: selectedCategories)
        currentIndex = 0
        selectedAnswer = nil
        showExplanation = false
        score = 0
        streak = 0
        bestStreak = 0
        quizComplete = false
        showSetup = false
    }

    private func selectAnswer(_ index: Int) {
        withAnimation(.spring(response: 0.3)) {
            selectedAnswer = index
            showExplanation = true
        }

        let isCorrect = index == questions[currentIndex].correctIndex
        if isCorrect {
            score += 1
            streak += 1
            bestStreak = max(bestStreak, streak)
        } else {
            streak = 0
        }

        totalAnswered += 1
        if isCorrect { totalCorrect += 1 }

        #if os(iOS)
        if isCorrect {
            hapticSuccess.notificationOccurred(.success)
        } else {
            hapticError.notificationOccurred(.error)
        }
        #endif
    }

    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            withAnimation {
                currentIndex += 1
                selectedAnswer = nil
                showExplanation = false
            }
        } else {
            // Quiz complete
            if score > highScore {
                highScore = score
            }
            withAnimation {
                quizComplete = true
            }
        }
    }
}
