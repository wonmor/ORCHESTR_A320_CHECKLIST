package com.orchestrsim.a320guide.ui.screens

import android.content.Context
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.orchestrsim.a320guide.data.*
import com.orchestrsim.a320guide.ui.theme.AppColors

// MARK: - Checklist Category Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChecklistCategoryScreen(
    checklists: List<Checklist>,
    onChecklistClick: (Int) -> Unit
) {
    val context = LocalContext.current
    var searchQuery by rememberSaveable { mutableStateOf("") }

    // Completion state persisted via SharedPreferences
    val completionState = remember { mutableStateMapOf<String, Boolean>() }

    LaunchedEffect(Unit) {
        val prefs = context.getSharedPreferences("checklist_prefs", Context.MODE_PRIVATE)
        checklists.forEach { checklist ->
            checklist.items.forEach { item ->
                val saved = prefs.getBoolean("checklist_${item.id}", false)
                item.isCompleted = saved
                completionState[item.id] = saved
            }
        }
    }

    val filteredChecklists = remember(searchQuery, checklists) {
        if (searchQuery.isBlank()) checklists
        else checklists.filter {
            it.title.contains(searchQuery, ignoreCase = true) ||
                    it.subtitle.contains(searchQuery, ignoreCase = true)
        }
    }

    val groupedChecklists = remember(filteredChecklists) {
        FlightPhase.entries.mapNotNull { phase ->
            val items = filteredChecklists.filter { it.phase == phase }
            if (items.isNotEmpty()) phase to items else null
        }
    }

    val totalItems = checklists.sumOf { it.items.size }
    val completedItems = completionState.values.count { it }
    val progress = if (totalItems > 0) completedItems.toFloat() / totalItems else 0f

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Normal Checklists") },
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
            contentPadding = PaddingValues(bottom = 16.dp)
        ) {
            // Search bar
            item {
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    placeholder = { Text("Search checklists...") },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                    singleLine = true,
                    shape = RoundedCornerShape(12.dp)
                )
            }

            // Progress section
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                "Overall Progress",
                                style = MaterialTheme.typography.titleSmall
                            )
                            Text(
                                "$completedItems/$totalItems",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        LinearProgressIndicator(
                            progress = { progress },
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(6.dp)
                                .clip(RoundedCornerShape(3.dp)),
                            color = AppColors.cyan,
                            trackColor = MaterialTheme.colorScheme.surface,
                        )
                        if (completedItems == totalItems && totalItems > 0) {
                            Spacer(modifier = Modifier.height(8.dp))
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    Icons.Default.CheckCircle,
                                    contentDescription = null,
                                    tint = AppColors.green,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(4.dp))
                                Text(
                                    "All checklists complete",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = AppColors.green
                                )
                            }
                        }
                    }
                }
            }

            // Grouped checklists by phase
            groupedChecklists.forEach { (phase, items) ->
                item {
                    Row(
                        modifier = Modifier.padding(start = 16.dp, top = 16.dp, bottom = 4.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            Icons.Default.FlightTakeoff,
                            contentDescription = null,
                            tint = phase.color,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            phase.displayName,
                            style = MaterialTheme.typography.titleSmall,
                            color = phase.color,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }

                items(items, key = { it.id }) { checklist ->
                    val checklistIndex = checklists.indexOf(checklist)
                    val completedCount = checklist.items.count { completionState[it.id] == true }
                    val isComplete = completedCount == checklist.items.size

                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp, vertical = 4.dp)
                            .clickable { onChecklistClick(checklistIndex) },
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.surfaceVariant
                        )
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                Icons.Default.Checklist,
                                contentDescription = null,
                                tint = if (isComplete) AppColors.green else checklist.color,
                                modifier = Modifier.size(28.dp)
                            )
                            Spacer(modifier = Modifier.width(12.dp))
                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    checklist.title,
                                    style = MaterialTheme.typography.titleSmall,
                                    textDecoration = if (isComplete) TextDecoration.LineThrough else TextDecoration.None
                                )
                                Text(
                                    checklist.subtitle,
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                )
                            }
                            Surface(
                                shape = RoundedCornerShape(12.dp),
                                color = if (isComplete) AppColors.green.copy(alpha = 0.2f)
                                else MaterialTheme.colorScheme.surface
                            ) {
                                Text(
                                    "$completedCount/${checklist.items.size}",
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
                                    style = MaterialTheme.typography.labelSmall
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Checklist Detail Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChecklistDetailScreen(
    checklist: Checklist,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val prefs = remember { context.getSharedPreferences("checklist_prefs", Context.MODE_PRIVATE) }

    // Local mutable state for each item completion
    val completionState = remember {
        mutableStateMapOf<String, Boolean>().apply {
            checklist.items.forEach { item ->
                put(item.id, prefs.getBoolean("checklist_${item.id}", false))
            }
        }
    }

    var showResetDialog by remember { mutableStateOf(false) }

    val completedCount = completionState.values.count { it }
    val totalCount = checklist.items.size
    val progress = if (totalCount > 0) completedCount.toFloat() / totalCount else 0f

    fun saveState(itemId: String, completed: Boolean) {
        prefs.edit().putBoolean("checklist_$itemId", completed).apply()
    }

    fun toggleItem(item: ChecklistItem) {
        val newState = !(completionState[item.id] ?: false)
        completionState[item.id] = newState
        item.isCompleted = newState
        saveState(item.id, newState)
    }

    fun completeAll() {
        checklist.items.forEach { item ->
            completionState[item.id] = true
            item.isCompleted = true
            saveState(item.id, true)
        }
    }

    fun resetAll() {
        checklist.items.forEach { item ->
            completionState[item.id] = false
            item.isCompleted = false
            saveState(item.id, false)
        }
    }

    if (showResetDialog) {
        AlertDialog(
            onDismissRequest = { showResetDialog = false },
            title = { Text("Reset Checklist?") },
            text = { Text("This will uncheck all items in ${checklist.title}.") },
            confirmButton = {
                TextButton(onClick = {
                    resetAll()
                    showResetDialog = false
                }) {
                    Text("Reset", color = AppColors.red)
                }
            },
            dismissButton = {
                TextButton(onClick = { showResetDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(checklist.title) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    var menuExpanded by remember { mutableStateOf(false) }
                    IconButton(onClick = { menuExpanded = true }) {
                        Icon(Icons.Default.MoreVert, contentDescription = "Options")
                    }
                    DropdownMenu(
                        expanded = menuExpanded,
                        onDismissRequest = { menuExpanded = false }
                    ) {
                        DropdownMenuItem(
                            text = { Text("Complete All") },
                            leadingIcon = {
                                Icon(Icons.Default.CheckCircle, contentDescription = null)
                            },
                            onClick = {
                                completeAll()
                                menuExpanded = false
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Reset All") },
                            leadingIcon = {
                                Icon(Icons.Default.Refresh, contentDescription = null)
                            },
                            onClick = {
                                menuExpanded = false
                                showResetDialog = true
                            }
                        )
                    }
                },
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
            contentPadding = PaddingValues(bottom = 16.dp)
        ) {
            // Phase and progress header
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                checklist.phase.displayName,
                                style = MaterialTheme.typography.labelMedium,
                                color = checklist.phase.color
                            )
                            Text(
                                "$completedCount/$totalCount",
                                style = MaterialTheme.typography.titleSmall,
                                fontWeight = FontWeight.Bold
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        LinearProgressIndicator(
                            progress = { progress },
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(6.dp)
                                .clip(RoundedCornerShape(3.dp)),
                            color = if (completedCount == totalCount) AppColors.green else AppColors.cyan,
                            trackColor = MaterialTheme.colorScheme.surface,
                        )
                    }
                }
            }

            // Section header
            item {
                Text(
                    "Items",
                    modifier = Modifier.padding(start = 16.dp, top = 12.dp, bottom = 4.dp),
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            // Checklist items
            itemsIndexed(checklist.items, key = { _, item -> item.id }) { _, item ->
                val isCompleted = completionState[item.id] ?: false
                ChecklistItemRow(
                    challenge = item.challenge,
                    response = item.response,
                    notes = item.notes,
                    isCompleted = isCompleted,
                    onToggle = { toggleItem(item) }
                )
            }
        }
    }
}

// MARK: - Checklist Item Row

@Composable
private fun ChecklistItemRow(
    challenge: String,
    response: String,
    notes: String?,
    isCompleted: Boolean,
    onToggle: () -> Unit
) {
    var showNotes by remember { mutableStateOf(false) }
    val checkColor by animateColorAsState(
        targetValue = if (isCompleted) AppColors.green else MaterialTheme.colorScheme.onSurfaceVariant,
        animationSpec = spring(stiffness = Spring.StiffnessMediumLow),
        label = "checkColor"
    )

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 3.dp)
            .clickable { onToggle() },
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Row(
                verticalAlignment = Alignment.Top
            ) {
                Icon(
                    if (isCompleted) Icons.Default.CheckCircle else Icons.Default.RadioButtonUnchecked,
                    contentDescription = null,
                    tint = checkColor,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(10.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(
                            challenge,
                            style = MaterialTheme.typography.bodyMedium.copy(
                                fontWeight = FontWeight.Bold,
                                textDecoration = if (isCompleted) TextDecoration.LineThrough else TextDecoration.None
                            ),
                            color = if (isCompleted) MaterialTheme.colorScheme.onSurfaceVariant
                            else MaterialTheme.colorScheme.onSurface,
                            modifier = Modifier.weight(1f)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            response,
                            style = MaterialTheme.typography.bodyMedium.copy(
                                fontFamily = FontFamily.Monospace
                            ),
                            color = if (isCompleted) AppColors.green else AppColors.cyan
                        )
                    }

                    if (notes != null && showNotes) {
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            notes,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            if (notes != null) {
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    if (showNotes) "Hide notes" else "Show notes",
                    modifier = Modifier
                        .padding(start = 34.dp)
                        .clickable { showNotes = !showNotes },
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
