package com.orchestrsim.a320guide.ui.screens

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import com.orchestrsim.a320guide.data.*
import com.orchestrsim.a320guide.ui.theme.AppColors

// MARK: - Emergency List Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EmergencyListScreen(
    procedures: List<EmergencyProcedure>,
    onProcedureClick: (EmergencyProcedure) -> Unit
) {
    var searchQuery by rememberSaveable { mutableStateOf("") }
    var selectedSeverity by rememberSaveable { mutableStateOf<EmergencySeverity?>(null) }

    val filtered = remember(searchQuery, selectedSeverity, procedures) {
        var result = procedures
        selectedSeverity?.let { sev ->
            result = result.filter { it.severity == sev }
        }
        if (searchQuery.isNotBlank()) {
            result = result.filter {
                it.title.contains(searchQuery, ignoreCase = true) ||
                        it.subtitle.contains(searchQuery, ignoreCase = true)
            }
        }
        result
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Emergency Procedures") },
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
                    placeholder = { Text("Search procedures...") },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                    singleLine = true,
                    shape = RoundedCornerShape(12.dp)
                )
            }

            // Filter chips
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    FilterChip(
                        selected = selectedSeverity == null,
                        onClick = { selectedSeverity = null },
                        label = { Text("All") },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = AppColors.cyan.copy(alpha = 0.3f),
                            selectedLabelColor = AppColors.cyan
                        )
                    )
                    EmergencySeverity.entries.forEach { severity ->
                        FilterChip(
                            selected = selectedSeverity == severity,
                            onClick = {
                                selectedSeverity = if (selectedSeverity == severity) null else severity
                            },
                            label = { Text(severity.displayName, style = MaterialTheme.typography.labelSmall) },
                            colors = FilterChipDefaults.filterChipColors(
                                selectedContainerColor = severity.color.copy(alpha = 0.3f),
                                selectedLabelColor = severity.color
                            )
                        )
                    }
                }
            }

            // Procedure list
            items(filtered, key = { it.id }) { procedure ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp)
                        .clickable { onProcedureClick(procedure) },
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                ) {
                    Row(
                        modifier = Modifier.padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            Icons.Default.Warning,
                            contentDescription = null,
                            tint = procedure.severity.color,
                            modifier = Modifier.size(28.dp)
                        )
                        Spacer(modifier = Modifier.width(12.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    procedure.title,
                                    style = MaterialTheme.typography.titleSmall,
                                    modifier = Modifier.weight(1f)
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Surface(
                                    shape = RoundedCornerShape(12.dp),
                                    color = procedure.severity.color.copy(alpha = 0.2f)
                                ) {
                                    Text(
                                        procedure.severity.displayName,
                                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp),
                                        style = MaterialTheme.typography.labelSmall,
                                        color = procedure.severity.color,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                            Text(
                                procedure.subtitle,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Emergency Detail Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EmergencyDetailScreen(
    procedure: EmergencyProcedure,
    onBack: () -> Unit
) {
    val completedSteps = remember { mutableStateMapOf<String, Boolean>() }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(procedure.title) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = { completedSteps.clear() }) {
                        Icon(Icons.Default.Refresh, contentDescription = "Reset")
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
            // Severity banner
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = procedure.severity.color.copy(alpha = 0.1f)
                    )
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                Icons.Default.Warning,
                                contentDescription = null,
                                tint = procedure.severity.color
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                procedure.severity.displayName,
                                style = MaterialTheme.typography.titleMedium,
                                fontWeight = FontWeight.Bold,
                                color = procedure.severity.color
                            )
                        }
                        Icon(
                            Icons.Default.Warning,
                            contentDescription = null,
                            tint = procedure.severity.color,
                            modifier = Modifier.size(28.dp)
                        )
                    }
                }
            }

            // Memory items
            if (procedure.memoryItems.isNotEmpty()) {
                item {
                    Text(
                        "MEMORY ITEMS",
                        modifier = Modifier.padding(start = 16.dp, top = 16.dp, bottom = 4.dp),
                        style = MaterialTheme.typography.titleSmall,
                        color = AppColors.red,
                        fontWeight = FontWeight.Bold
                    )
                }

                items(procedure.memoryItems) { memoryItem ->
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp, vertical = 2.dp),
                        colors = CardDefaults.cardColors(
                            containerColor = AppColors.red.copy(alpha = 0.08f)
                        )
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                Icons.Default.Psychology,
                                contentDescription = null,
                                tint = AppColors.red,
                                modifier = Modifier.size(16.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                memoryItem,
                                style = MaterialTheme.typography.bodyMedium.copy(
                                    fontFamily = FontFamily.Monospace,
                                    fontWeight = FontWeight.Bold
                                ),
                                color = AppColors.red
                            )
                        }
                    }
                }

                item {
                    Text(
                        "Memory items must be performed from recall -- no reference to checklist required.",
                        modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            // Procedure steps
            item {
                Text(
                    "Procedure Steps",
                    modifier = Modifier.padding(start = 16.dp, top = 16.dp, bottom = 4.dp),
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            items(procedure.steps, key = { it.id }) { step ->
                val isCompleted = completedSteps[step.id] ?: false
                ProcedureStepRow(
                    step = step,
                    isCompleted = isCompleted,
                    onToggle = {
                        completedSteps[step.id] = !isCompleted
                    }
                )
            }

            // Notes
            if (procedure.notes.isNotEmpty()) {
                item {
                    Text(
                        "Notes",
                        modifier = Modifier.padding(start = 16.dp, top = 16.dp, bottom = 4.dp),
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                items(procedure.notes) { note ->
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp, vertical = 2.dp),
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.surfaceVariant
                        )
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.Top
                        ) {
                            Icon(
                                Icons.Default.Info,
                                contentDescription = null,
                                tint = AppColors.blue,
                                modifier = Modifier.size(16.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                note,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Procedure Step Row (shared between Emergency and Approach)

@Composable
fun ProcedureStepRow(
    step: ProcedureStep,
    isCompleted: Boolean,
    onToggle: () -> Unit
) {
    val checkColor by animateColorAsState(
        targetValue = if (isCompleted) AppColors.green else MaterialTheme.colorScheme.onSurfaceVariant,
        animationSpec = spring(stiffness = Spring.StiffnessMediumLow),
        label = "stepCheckColor"
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
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.Top
        ) {
            Icon(
                if (isCompleted) Icons.Default.CheckCircle else Icons.Default.RadioButtonUnchecked,
                contentDescription = null,
                tint = checkColor,
                modifier = Modifier.size(24.dp)
            )
            Spacer(modifier = Modifier.width(10.dp))
            Column {
                Text(
                    step.action,
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.Bold,
                        textDecoration = if (isCompleted) TextDecoration.LineThrough else TextDecoration.None
                    ),
                    color = if (isCompleted) MaterialTheme.colorScheme.onSurfaceVariant
                    else MaterialTheme.colorScheme.onSurface
                )

                step.detail?.let { detail ->
                    Text(
                        detail,
                        style = MaterialTheme.typography.bodySmall,
                        color = if (isCompleted) MaterialTheme.colorScheme.onSurfaceVariant
                        else AppColors.cyan
                    )
                }

                if (step.isConditional && step.condition != null) {
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            Icons.Default.SubdirectoryArrowRight,
                            contentDescription = null,
                            tint = AppColors.orange,
                            modifier = Modifier.size(14.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            "IF: ${step.condition}",
                            style = MaterialTheme.typography.labelSmall,
                            color = AppColors.orange
                        )
                    }
                }
            }
        }
    }
}
