package com.orchestrsim.a320guide.ui.screens

import android.content.Context
import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.orchestrsim.a320guide.data.*
import com.orchestrsim.a320guide.ui.theme.AppColors

// MARK: - Quiz Screen (Main Container)

@Composable
fun QuizScreen(
    allQuestions: List<QuizQuestion>
) {
    val context = LocalContext.current
    val prefs = remember { context.getSharedPreferences("quiz_prefs", Context.MODE_PRIVATE) }

    var showSetup by rememberSaveable { mutableStateOf(true) }
    var quizComplete by rememberSaveable { mutableStateOf(false) }
    var questions by remember { mutableStateOf<List<QuizQuestion>>(emptyList()) }
    var currentIndex by rememberSaveable { mutableStateOf(0) }
    var selectedAnswer by rememberSaveable { mutableStateOf<Int?>(null) }
    var showExplanation by rememberSaveable { mutableStateOf(false) }
    var score by rememberSaveable { mutableStateOf(0) }
    var streak by rememberSaveable { mutableStateOf(0) }
    var bestStreak by rememberSaveable { mutableStateOf(0) }
    var selectedCategories by remember {
        mutableStateOf(QuizCategory.entries.toSet())
    }
    var questionCount by rememberSaveable { mutableStateOf(10) }

    // Persisted stats
    var highScore by remember { mutableIntStateOf(prefs.getInt("highScore", 0)) }
    var totalAnswered by remember { mutableIntStateOf(prefs.getInt("totalAnswered", 0)) }
    var totalCorrect by remember { mutableIntStateOf(prefs.getInt("totalCorrect", 0)) }

    fun saveStats() {
        prefs.edit()
            .putInt("highScore", highScore)
            .putInt("totalAnswered", totalAnswered)
            .putInt("totalCorrect", totalCorrect)
            .apply()
    }

    fun startQuiz() {
        var filtered = allQuestions
        if (selectedCategories != QuizCategory.entries.toSet()) {
            filtered = filtered.filter { it.category in selectedCategories }
        }
        questions = filtered.shuffled().take(questionCount)
        currentIndex = 0
        selectedAnswer = null
        showExplanation = false
        score = 0
        streak = 0
        bestStreak = 0
        quizComplete = false
        showSetup = false
    }

    fun selectAnswer(index: Int) {
        selectedAnswer = index
        showExplanation = true
        val isCorrect = index == questions[currentIndex].correctIndex
        if (isCorrect) {
            score++
            streak++
            if (streak > bestStreak) bestStreak = streak
            totalCorrect++
        } else {
            streak = 0
        }
        totalAnswered++
        saveStats()
    }

    fun nextQuestion() {
        if (currentIndex < questions.size - 1) {
            currentIndex++
            selectedAnswer = null
            showExplanation = false
        } else {
            if (score > highScore) {
                highScore = score
                saveStats()
            }
            quizComplete = true
        }
    }

    when {
        showSetup -> QuizSetupScreen(
            selectedCategories = selectedCategories,
            onCategoryToggle = { category ->
                selectedCategories = if (selectedCategories.contains(category)) {
                    if (selectedCategories.size > 1) selectedCategories - category
                    else selectedCategories
                } else {
                    selectedCategories + category
                }
            },
            questionCount = questionCount,
            onQuestionCountChange = { questionCount = it },
            highScore = highScore,
            totalAnswered = totalAnswered,
            totalCorrect = totalCorrect,
            onStartQuiz = { startQuiz() }
        )
        quizComplete -> QuizResultsScreen(
            score = score,
            totalQuestions = questions.size,
            bestStreak = bestStreak,
            isNewHighScore = score > (highScore - score), // approximate: was this a new high score
            onTryAgain = { startQuiz() },
            onChangeSettings = {
                showSetup = true
                quizComplete = false
            }
        )
        questions.isNotEmpty() -> QuizQuestionScreen(
            question = questions[currentIndex],
            currentIndex = currentIndex,
            totalQuestions = questions.size,
            score = score,
            streak = streak,
            selectedAnswer = selectedAnswer,
            showExplanation = showExplanation,
            onSelectAnswer = { selectAnswer(it) },
            onNext = { nextQuestion() },
            isLastQuestion = currentIndex == questions.size - 1
        )
    }
}

// MARK: - Quiz Setup Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuizSetupScreen(
    selectedCategories: Set<QuizCategory>,
    onCategoryToggle: (QuizCategory) -> Unit,
    questionCount: Int,
    onQuestionCountChange: (Int) -> Unit,
    highScore: Int,
    totalAnswered: Int,
    totalCorrect: Int,
    onStartQuiz: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Quiz Mode") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background
                )
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Stats section
            item {
                Text(
                    "Your Stats",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(bottom = 4.dp)
                )
            }
            item {
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        StatRow(
                            icon = Icons.Default.Tag,
                            label = "Total Answered",
                            value = "$totalAnswered"
                        )
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        StatRow(
                            icon = Icons.Default.GpsFixed,
                            label = "Accuracy",
                            value = if (totalAnswered > 0)
                                "${(totalCorrect * 100 / totalAnswered)}%"
                            else "\u2014"
                        )
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        StatRow(
                            icon = Icons.Default.EmojiEvents,
                            iconTint = AppColors.yellow,
                            label = "High Score",
                            value = "$highScore/$questionCount",
                            valueColor = AppColors.yellow
                        )
                    }
                }
            }

            // Category selection
            item {
                Text(
                    "Categories",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(top = 8.dp, bottom = 4.dp)
                )
            }
            item {
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                ) {
                    Column(modifier = Modifier.padding(8.dp)) {
                        QuizCategory.entries.forEach { category ->
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable { onCategoryToggle(category) }
                                    .padding(horizontal = 12.dp, vertical = 10.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(
                                    Icons.Default.Category,
                                    contentDescription = null,
                                    tint = category.color,
                                    modifier = Modifier.size(24.dp)
                                )
                                Spacer(modifier = Modifier.width(12.dp))
                                Text(
                                    category.displayName,
                                    style = MaterialTheme.typography.bodyMedium,
                                    modifier = Modifier.weight(1f)
                                )
                                Icon(
                                    if (selectedCategories.contains(category))
                                        Icons.Default.CheckCircle
                                    else Icons.Default.RadioButtonUnchecked,
                                    contentDescription = null,
                                    tint = if (selectedCategories.contains(category))
                                        category.color
                                    else MaterialTheme.colorScheme.onSurfaceVariant
                                )
                            }
                        }
                    }
                }
            }

            // Question count picker
            item {
                Text(
                    "Questions",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(top = 8.dp, bottom = 4.dp)
                )
            }
            item {
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(12.dp),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        listOf(5, 10, 15, 20).forEach { count ->
                            FilterChip(
                                selected = questionCount == count,
                                onClick = { onQuestionCountChange(count) },
                                label = { Text("$count") },
                                modifier = Modifier.weight(1f),
                                colors = FilterChipDefaults.filterChipColors(
                                    selectedContainerColor = AppColors.cyan.copy(alpha = 0.3f),
                                    selectedLabelColor = AppColors.cyan
                                )
                            )
                        }
                    }
                }
            }

            // Start button
            item {
                Spacer(modifier = Modifier.height(8.dp))
                Button(
                    onClick = onStartQuiz,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = AppColors.cyan.copy(alpha = 0.2f),
                        contentColor = AppColors.cyan
                    )
                ) {
                    Icon(Icons.Default.PlayArrow, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Start Quiz", fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

// MARK: - Quiz Question Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuizQuestionScreen(
    question: QuizQuestion,
    currentIndex: Int,
    totalQuestions: Int,
    score: Int,
    streak: Int,
    selectedAnswer: Int?,
    showExplanation: Boolean,
    onSelectAnswer: (Int) -> Unit,
    onNext: () -> Unit,
    isLastQuestion: Boolean
) {
    val answerLabels = listOf("A", "B", "C", "D")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Quiz") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background
                )
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Progress
            Column {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        "Question ${currentIndex + 1} of $totalQuestions",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            Icons.Default.LocalFireDepartment,
                            contentDescription = null,
                            tint = if (streak > 0) AppColors.orange else MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            "$streak",
                            style = MaterialTheme.typography.bodySmall,
                            color = if (streak > 0) AppColors.orange else MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                LinearProgressIndicator(
                    progress = { currentIndex.toFloat() / totalQuestions },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(4.dp)
                        .clip(RoundedCornerShape(2.dp)),
                    color = AppColors.cyan,
                    trackColor = MaterialTheme.colorScheme.surfaceVariant,
                )
            }

            // Score display
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Default.CheckCircle,
                        contentDescription = null,
                        tint = AppColors.green,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("$score", fontWeight = FontWeight.Bold)
                }
                Spacer(modifier = Modifier.width(20.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Default.Cancel,
                        contentDescription = null,
                        tint = AppColors.red,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        "${currentIndex - score + if (selectedAnswer != null) 0 else 0}",
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            // Category badge
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center
            ) {
                Surface(
                    shape = RoundedCornerShape(16.dp),
                    color = question.category.color.copy(alpha = 0.2f)
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            Icons.Default.Category,
                            contentDescription = null,
                            tint = question.category.color,
                            modifier = Modifier.size(14.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            question.category.displayName,
                            style = MaterialTheme.typography.labelSmall,
                            fontWeight = FontWeight.Bold,
                            color = question.category.color
                        )
                    }
                }
            }

            // Question text
            Text(
                question.question,
                style = MaterialTheme.typography.titleMedium.copy(
                    fontWeight = FontWeight.Bold
                ),
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )

            // Answer choices
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                question.choices.forEachIndexed { index, choice ->
                    val backgroundColor by animateColorAsState(
                        targetValue = when {
                            selectedAnswer == null -> MaterialTheme.colorScheme.surfaceVariant
                            index == question.correctIndex -> AppColors.green.copy(alpha = 0.2f)
                            index == selectedAnswer -> AppColors.red.copy(alpha = 0.2f)
                            else -> MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
                        },
                        label = "answerBg"
                    )
                    val borderColor by animateColorAsState(
                        targetValue = when {
                            selectedAnswer == null -> MaterialTheme.colorScheme.outline.copy(alpha = 0.3f)
                            index == question.correctIndex -> AppColors.green
                            index == selectedAnswer -> AppColors.red
                            else -> Color.Transparent
                        },
                        label = "answerBorder"
                    )

                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable(enabled = selectedAnswer == null) {
                                onSelectAnswer(index)
                            },
                        colors = CardDefaults.cardColors(containerColor = backgroundColor),
                        border = BorderStroke(2.dp, borderColor),
                        shape = RoundedCornerShape(12.dp)
                    ) {
                        Row(
                            modifier = Modifier.padding(14.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                answerLabels[index],
                                style = MaterialTheme.typography.titleSmall.copy(
                                    fontFamily = FontFamily.Monospace,
                                    fontWeight = FontWeight.Bold
                                ),
                                modifier = Modifier.width(30.dp)
                            )
                            Text(
                                choice,
                                style = MaterialTheme.typography.bodyMedium,
                                modifier = Modifier.weight(1f)
                            )
                            if (selectedAnswer != null) {
                                if (index == question.correctIndex) {
                                    Icon(
                                        Icons.Default.CheckCircle,
                                        contentDescription = null,
                                        tint = AppColors.green
                                    )
                                } else if (index == selectedAnswer && selectedAnswer != question.correctIndex) {
                                    Icon(
                                        Icons.Default.Cancel,
                                        contentDescription = null,
                                        tint = AppColors.red
                                    )
                                }
                            }
                        }
                    }
                }
            }

            // Explanation
            if (showExplanation) {
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = AppColors.yellow.copy(alpha = 0.1f)
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                Icons.Default.Lightbulb,
                                contentDescription = null,
                                tint = AppColors.yellow
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                "Explanation",
                                style = MaterialTheme.typography.titleSmall,
                                color = AppColors.yellow
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            question.explanation,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }

                // Next button
                Button(
                    onClick = onNext,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = AppColors.cyan.copy(alpha = 0.2f),
                        contentColor = AppColors.cyan
                    )
                ) {
                    Text(
                        if (isLastQuestion) "See Results" else "Next Question",
                        fontWeight = FontWeight.Bold
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Icon(Icons.Default.ArrowForward, contentDescription = null)
                }
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

// MARK: - Quiz Results Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuizResultsScreen(
    score: Int,
    totalQuestions: Int,
    bestStreak: Int,
    isNewHighScore: Boolean,
    onTryAgain: () -> Unit,
    onChangeSettings: () -> Unit
) {
    val percentage = if (totalQuestions > 0) score.toFloat() / totalQuestions else 0f
    val scoreColor = when {
        percentage >= 0.8f -> AppColors.green
        percentage >= 0.6f -> AppColors.yellow
        else -> AppColors.red
    }
    val gradeMessage = when {
        percentage >= 0.9f -> "Outstanding! Type Rating Ready"
        percentage >= 0.8f -> "Great Job! Almost There"
        percentage >= 0.6f -> "Good Effort, Keep Studying"
        percentage >= 0.4f -> "More Study Needed"
        else -> "Review the Material and Try Again"
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Results") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background
                )
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            Spacer(modifier = Modifier.height(16.dp))

            // Score circle
            Box(
                contentAlignment = Alignment.Center,
                modifier = Modifier.size(160.dp)
            ) {
                CircularProgressIndicator(
                    progress = { 1f },
                    modifier = Modifier.fillMaxSize(),
                    strokeWidth = 12.dp,
                    color = MaterialTheme.colorScheme.surfaceVariant,
                    trackColor = Color.Transparent,
                )
                CircularProgressIndicator(
                    progress = { percentage },
                    modifier = Modifier.fillMaxSize(),
                    strokeWidth = 12.dp,
                    color = scoreColor,
                    trackColor = Color.Transparent,
                    strokeCap = StrokeCap.Round
                )
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        "$score/$totalQuestions",
                        style = MaterialTheme.typography.headlineLarge.copy(
                            fontWeight = FontWeight.Bold
                        )
                    )
                    Text(
                        "${(percentage * 100).toInt()}%",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            // Grade message
            Text(
                gradeMessage,
                style = MaterialTheme.typography.titleLarge.copy(
                    fontWeight = FontWeight.Bold
                ),
                textAlign = TextAlign.Center
            )

            // Stats card
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    StatRow(
                        icon = Icons.Default.CheckCircle,
                        iconTint = AppColors.green,
                        label = "Correct",
                        value = "$score"
                    )
                    HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                    StatRow(
                        icon = Icons.Default.Cancel,
                        iconTint = AppColors.red,
                        label = "Incorrect",
                        value = "${totalQuestions - score}"
                    )
                    HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                    StatRow(
                        icon = Icons.Default.LocalFireDepartment,
                        iconTint = AppColors.orange,
                        label = "Best Streak",
                        value = "$bestStreak"
                    )
                    if (isNewHighScore) {
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        StatRow(
                            icon = Icons.Default.EmojiEvents,
                            iconTint = AppColors.yellow,
                            label = "New High Score!",
                            value = "$score",
                            valueColor = AppColors.yellow
                        )
                    }
                }
            }

            // Action buttons
            Column(
                modifier = Modifier.fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Button(
                    onClick = onTryAgain,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = AppColors.cyan.copy(alpha = 0.2f),
                        contentColor = AppColors.cyan
                    )
                ) {
                    Icon(Icons.Default.Refresh, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Try Again", fontWeight = FontWeight.Bold)
                }

                Button(
                    onClick = onChangeSettings,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant,
                        contentColor = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                ) {
                    Icon(Icons.Default.Settings, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Change Settings", fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

// MARK: - Stat Row Helper

@Composable
private fun StatRow(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    iconTint: Color = MaterialTheme.colorScheme.onSurfaceVariant,
    label: String,
    value: String,
    valueColor: Color = MaterialTheme.colorScheme.onSurface
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            icon,
            contentDescription = null,
            tint = iconTint,
            modifier = Modifier.size(20.dp)
        )
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            label,
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.weight(1f)
        )
        Text(
            value,
            style = MaterialTheme.typography.titleSmall,
            fontWeight = FontWeight.Bold,
            color = valueColor
        )
    }
}
