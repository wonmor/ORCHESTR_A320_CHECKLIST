package com.orchestrsim.a320guide.data

import com.orchestrsim.a320guide.ui.theme.AppColors

object QuizGenerator {

    fun generateQuestions(count: Int = 20, categories: Set<QuizCategory>? = null): List<QuizQuestion> {
        var allQuestions = mutableListOf<QuizQuestion>()

        allQuestions.addAll(checklistQuestions())
        allQuestions.addAll(emergencyQuestions())
        allQuestions.addAll(approachQuestions())
        allQuestions.addAll(systemsQuestions())
        allQuestions.addAll(limitationsQuestions())

        if (categories != null) {
            allQuestions = allQuestions.filter { it.category in categories }.toMutableList()
        }

        return allQuestions.shuffled().take(count)
    }

    private fun checklistQuestions(): List<QuizQuestion> {
        val questions = mutableListOf<QuizQuestion>()
        val allResponses = A320Database.normalChecklists.flatMap { it.items }.map { it.response }

        for (checklist in A320Database.normalChecklists) {
            for (item in checklist.items) {
                val wrongAnswers = allResponses.filter { it != item.response }.distinct().shuffled().take(3)
                if (wrongAnswers.size >= 3) {
                    val choices = (listOf(item.response) + wrongAnswers).shuffled()
                    val correctIdx = choices.indexOf(item.response)
                    questions.add(
                        QuizQuestion(
                            question = "During ${checklist.title}, what is the correct response for \"${item.challenge}\"?",
                            choices = choices,
                            correctIndex = correctIdx,
                            category = QuizCategory.CHECKLISTS,
                            explanation = item.notes ?: "Standard ${checklist.title} procedure item."
                        )
                    )
                }
            }
        }
        return questions
    }

    private fun emergencyQuestions(): List<QuizQuestion> {
        val questions = mutableListOf<QuizQuestion>()
        val procedures = A320Database.emergencyProcedures
        val allMemoryItems = procedures.flatMap { it.memoryItems }

        for (proc in procedures) {
            // Memory items questions
            for (item in proc.memoryItems) {
                val wrong = allMemoryItems.filter { it != item }.shuffled().take(3)
                if (wrong.size >= 3) {
                    val choices = (listOf(item) + wrong).shuffled()
                    questions.add(
                        QuizQuestion(
                            question = "Which is a MEMORY ITEM for \"${proc.title}\"?",
                            choices = choices,
                            correctIndex = choices.indexOf(item),
                            category = QuizCategory.EMERGENCY,
                            explanation = "Memory items must be performed from recall without reference to the checklist."
                        )
                    )
                }
            }

            // Severity questions
            val wrongSeverities = EmergencySeverity.entries.filter { it != proc.severity }
            val allChoices = (listOf(proc.severity.displayName) + wrongSeverities.map { it.displayName }).shuffled()
            questions.add(
                QuizQuestion(
                    question = "What is the severity level of \"${proc.title}\"?",
                    choices = allChoices,
                    correctIndex = allChoices.indexOf(proc.severity.displayName),
                    category = QuizCategory.EMERGENCY,
                    explanation = "${proc.title} is classified as ${proc.severity.displayName}."
                )
            )
        }
        return questions
    }

    private fun approachQuestions(): List<QuizQuestion> {
        val questions = mutableListOf<QuizQuestion>()
        val approaches = A320Database.approachProcedures

        for (approach in approaches) {
            val wrongMinimums = approaches.filter { it.id != approach.id }.map { it.minimums }.shuffled().take(3)
            if (wrongMinimums.size >= 3) {
                val choices = (listOf(approach.minimums) + wrongMinimums).shuffled()
                questions.add(
                    QuizQuestion(
                        question = "What are the minimums for a ${approach.name}?",
                        choices = choices,
                        correctIndex = choices.indexOf(approach.minimums),
                        category = QuizCategory.APPROACHES,
                        explanation = approach.description
                    )
                )
            }
        }
        return questions
    }

    private fun systemsQuestions(): List<QuizQuestion> = listOf(
        QuizQuestion(
            question = "How many hydraulic systems does the A320 have?",
            choices = listOf("2 (Left, Right)", "3 (Green, Blue, Yellow)", "4 (A, B, C, D)", "2 (Primary, Secondary)"),
            correctIndex = 1, category = QuizCategory.SYSTEMS,
            explanation = "The A320 has three independent hydraulic systems: Green, Blue, and Yellow."
        ),
        QuizQuestion(
            question = "What powers the Blue hydraulic system in an emergency?",
            choices = listOf("APU", "RAT (Ram Air Turbine)", "Battery", "Crossfeed from Green"),
            correctIndex = 1, category = QuizCategory.SYSTEMS,
            explanation = "The RAT auto-deploys and powers the Blue hydraulic system and emergency generator."
        ),
        QuizQuestion(
            question = "What is the A320 normal hydraulic operating pressure?",
            choices = listOf("1,500 psi", "2,000 psi", "3,000 psi", "5,000 psi"),
            correctIndex = 2, category = QuizCategory.SYSTEMS,
            explanation = "All three hydraulic systems operate at 3,000 psi."
        ),
        QuizQuestion(
            question = "How many flight control computers does the A320 have?",
            choices = listOf("3 (1 ELAC + 1 SEC + 1 FAC)", "5 (2 ELAC + 2 SEC + 1 FAC)", "7 (2 ELAC + 3 SEC + 2 FAC)", "4 (2 ELAC + 2 SEC)"),
            correctIndex = 2, category = QuizCategory.SYSTEMS,
            explanation = "The A320 has 7 flight control computers: 2 ELAC, 3 SEC, and 2 FAC."
        ),
        QuizQuestion(
            question = "What is the correct flight control law degradation sequence?",
            choices = listOf("Normal → Direct → Mechanical", "Normal → Alternate → Direct → Mechanical", "Normal → Backup → Emergency", "Normal → Degraded → Manual"),
            correctIndex = 1, category = QuizCategory.SYSTEMS,
            explanation = "Control law degrades: Normal → Alternate → Direct → Mechanical backup (pitch trim + rudder only)."
        ),
        QuizQuestion(
            question = "What does the PTU connect?",
            choices = listOf("Green and Blue systems", "Blue and Yellow systems", "Green and Yellow systems", "All three systems"),
            correctIndex = 2, category = QuizCategory.SYSTEMS,
            explanation = "The Power Transfer Unit provides cross-connection between Green and Yellow hydraulic systems."
        ),
        QuizQuestion(
            question = "How many AC generators does the A320 have (including APU)?",
            choices = listOf("2", "3", "4", "5"),
            correctIndex = 1, category = QuizCategory.SYSTEMS,
            explanation = "Two IDGs (one per engine, 90 kVA each) plus one APU generator (90 kVA)."
        ),
        QuizQuestion(
            question = "What is the emergency battery endurance?",
            choices = listOf("~10 minutes", "~30 minutes", "~60 minutes", "~120 minutes"),
            correctIndex = 1, category = QuizCategory.SYSTEMS,
            explanation = "Two 25Ah batteries provide approximately 30 minutes on the hot battery bus."
        ),
        QuizQuestion(
            question = "Which engine drives the Green hydraulic system?",
            choices = listOf("Engine 1", "Engine 2", "Either engine", "APU"),
            correctIndex = 0, category = QuizCategory.SYSTEMS,
            explanation = "The Green system is powered by an Engine-Driven Pump (EDP) on Engine 1."
        ),
        QuizQuestion(
            question = "What does ELAC stand for?",
            choices = listOf("Electronic Landing Approach Computer", "Elevator/Aileron Computer", "Engine Logic And Control", "Emergency Lateral Axis Computer"),
            correctIndex = 1, category = QuizCategory.SYSTEMS,
            explanation = "ELAC = Elevator/Aileron Computer. It handles normal law and autopilot commands."
        ),
        QuizQuestion(
            question = "What does FAC stand for?",
            choices = listOf("Flight Augmentation Computer", "Full Authority Controller", "Flight Automation Computer", "Fly-by-wire Actuator Controller"),
            correctIndex = 0, category = QuizCategory.SYSTEMS,
            explanation = "FAC = Flight Augmentation Computer. It handles yaw damper, rudder trim, and windshear detection."
        ),
    )

    private fun limitationsQuestions(): List<QuizQuestion> = listOf(
        QuizQuestion(
            question = "What is the A320 MMO (Maximum Mach Operating)?",
            choices = listOf("M 0.78", "M 0.80", "M 0.82", "M 0.84"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "MMO for the A320 is Mach 0.82."
        ),
        QuizQuestion(
            question = "What is the maximum cabin differential pressure?",
            choices = listOf("6.00 psi", "7.50 psi", "8.06 psi", "9.00 psi"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "Maximum differential pressure is 8.06 psi."
        ),
        QuizQuestion(
            question = "What is the typical cabin altitude at FL350?",
            choices = listOf("~4,000 ft", "~5,500 ft", "~6,900 ft", "~8,000 ft"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "At FL350, cabin altitude is approximately 6,900 feet."
        ),
        QuizQuestion(
            question = "What is the A320 MTOW (Maximum Takeoff Weight)?",
            choices = listOf("64,500 kg", "73,500 kg", "78,000 kg", "85,000 kg"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "A320-200 MTOW is 78,000 kg (some variants differ slightly)."
        ),
        QuizQuestion(
            question = "What is the total usable fuel capacity by weight?",
            choices = listOf("~12,000 kg", "~15,500 kg", "~18,730 kg", "~23,000 kg"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "Total usable fuel is approximately 18,730 kg (19,010 liters at 0.785 kg/L)."
        ),
        QuizQuestion(
            question = "What is the typical VREF at MLW in CONF FULL?",
            choices = listOf("~121 KIAS", "~131 KIAS", "~141 KIAS", "~151 KIAS"),
            correctIndex = 1, category = QuizCategory.LIMITATIONS,
            explanation = "VREF at maximum landing weight in CONF FULL is approximately 131 KIAS."
        ),
        QuizQuestion(
            question = "What is the standard ILS glideslope angle?",
            choices = listOf("2.5°", "3.0°", "3.5°", "4.0°"),
            correctIndex = 1, category = QuizCategory.LIMITATIONS,
            explanation = "Standard ILS glideslope is 3.0 degrees."
        ),
        QuizQuestion(
            question = "What is the approximate one-engine-inoperative ceiling at MTOW?",
            choices = listOf("~10,000 ft", "~15,000 ft", "~20,000 ft", "~25,000 ft"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "OEI ceiling at MTOW is approximately 20,000 ft (ISA conditions)."
        ),
        QuizQuestion(
            question = "What thrust lever detents exist on the A320?",
            choices = listOf("TOGA, MCT, CL, IDLE", "TOGA, FLX/MCT, CL, IDLE, REV", "TOGA, CLIMB, CRUISE, IDLE", "MAX, FLEX, CLIMB, IDLE, REV"),
            correctIndex = 1, category = QuizCategory.LIMITATIONS,
            explanation = "Thrust lever detents: TOGA, FLX/MCT, CL (Climb), IDLE, and REV (Reverse)."
        ),
        QuizQuestion(
            question = "What is the approximate ADIRS alignment time?",
            choices = listOf("~2 min", "~5 min", "~7 min", "~10 min"),
            correctIndex = 2, category = QuizCategory.LIMITATIONS,
            explanation = "Full NAV alignment of the ADIRS takes approximately 7 minutes."
        ),
    )
}
