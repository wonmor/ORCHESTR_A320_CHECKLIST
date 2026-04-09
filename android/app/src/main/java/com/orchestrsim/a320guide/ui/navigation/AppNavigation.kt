package com.orchestrsim.a320guide.ui.navigation

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.navigation.NavType
import androidx.navigation.compose.*
import androidx.navigation.navArgument
import com.orchestrsim.a320guide.data.A320Database
import com.orchestrsim.a320guide.data.ChecklistStore
import com.orchestrsim.a320guide.ui.screens.*

enum class AppTab(
    val title: String,
    val icon: ImageVector,
    val selectedIcon: ImageVector,
    val route: String
) {
    CHECKLISTS("Checklists", Icons.Outlined.Checklist, Icons.Filled.Checklist, "checklists"),
    EMERGENCY("Emergency", Icons.Outlined.Warning, Icons.Filled.Warning, "emergency"),
    VISUAL("Visual", Icons.Outlined.Visibility, Icons.Filled.Visibility, "visual"),
    APPROACHES("Approaches", Icons.Outlined.GpsFixed, Icons.Filled.GpsFixed, "approaches"),
    QUIZ("Quiz", Icons.Outlined.Psychology, Icons.Filled.Psychology, "quiz"),
    MORE("More", Icons.Outlined.MoreHoriz, Icons.Filled.MoreHoriz, "more");
}

@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    val currentBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = currentBackStackEntry?.destination?.route

    Scaffold(
        bottomBar = {
            NavigationBar(
                containerColor = MaterialTheme.colorScheme.surface,
                contentColor = MaterialTheme.colorScheme.onSurface
            ) {
                AppTab.entries.forEach { tab ->
                    val isSelected = when (tab) {
                        AppTab.CHECKLISTS -> currentRoute?.startsWith("checklist") == true
                        AppTab.EMERGENCY -> currentRoute?.startsWith("emergency") == true
                        AppTab.VISUAL -> currentRoute == "visual"
                        AppTab.APPROACHES -> currentRoute?.startsWith("approach") == true
                        AppTab.QUIZ -> currentRoute == "quiz"
                        AppTab.MORE -> currentRoute in listOf("more", "instruments", "fmgc", "poh") ||
                                currentRoute?.startsWith("instrument/") == true ||
                                currentRoute?.startsWith("fmgc/") == true ||
                                currentRoute?.startsWith("poh/") == true
                    }

                    NavigationBarItem(
                        icon = {
                            Icon(
                                if (isSelected) tab.selectedIcon else tab.icon,
                                contentDescription = tab.title
                            )
                        },
                        label = { Text(tab.title) },
                        selected = isSelected,
                        onClick = {
                            navController.navigate(tab.route) {
                                popUpTo(navController.graph.startDestinationId) { saveState = true }
                                launchSingleTop = true
                                restoreState = true
                            }
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = MaterialTheme.colorScheme.primary,
                            selectedTextColor = MaterialTheme.colorScheme.primary,
                            indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                        )
                    )
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = "checklists",
            modifier = Modifier.padding(innerPadding)
        ) {
            // Checklists
            composable("checklists") {
                ChecklistCategoryScreen(
                    checklists = ChecklistStore.checklists,
                    onChecklistClick = { index ->
                        navController.navigate("checklist/$index")
                    }
                )
            }
            composable(
                "checklist/{index}",
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                if (index < ChecklistStore.checklists.size) {
                    ChecklistDetailScreen(
                        checklist = ChecklistStore.checklists[index],
                        onBack = { navController.popBackStack() }
                    )
                }
            }

            // Emergency
            composable("emergency") {
                EmergencyListScreen(
                    procedures = A320Database.emergencyProcedures,
                    onProcedureClick = { proc ->
                        val index = A320Database.emergencyProcedures.indexOf(proc)
                        navController.navigate("emergency/$index")
                    }
                )
            }
            composable(
                "emergency/{index}",
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                if (index < A320Database.emergencyProcedures.size) {
                    EmergencyDetailScreen(
                        procedure = A320Database.emergencyProcedures[index],
                        onBack = { navController.popBackStack() }
                    )
                }
            }

            // Visual Sight Picture
            composable("visual") {
                VisualSightPictureScreen()
            }

            // Approaches
            composable("approaches") {
                ApproachListScreen(
                    procedures = A320Database.approachProcedures,
                    onProcedureClick = { proc ->
                        val index = A320Database.approachProcedures.indexOf(proc)
                        navController.navigate("approach/$index")
                    }
                )
            }
            composable(
                "approach/{index}",
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                if (index < A320Database.approachProcedures.size) {
                    ApproachDetailScreen(
                        procedure = A320Database.approachProcedures[index],
                        onBack = { navController.popBackStack() }
                    )
                }
            }

            // Quiz
            composable("quiz") {
                QuizScreen(
                    allQuestions = remember { com.orchestrsim.a320guide.data.QuizGenerator.generateQuestions(count = 100) }
                )
            }

            // More
            composable("more") {
                MoreScreen(
                    onInstrumentsClick = { navController.navigate("instruments") },
                    onFMGCClick = { navController.navigate("fmgc") },
                    onPOHClick = { navController.navigate("poh") }
                )
            }

            // Instruments
            composable("instruments") {
                InstrumentListScreen(
                    guides = A320Database.instrumentGuides,
                    onGuideClick = { guide ->
                        val index = A320Database.instrumentGuides.indexOf(guide)
                        navController.navigate("instrument/$index")
                    }
                )
            }
            composable(
                "instrument/{index}",
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                if (index < A320Database.instrumentGuides.size) {
                    InstrumentDetailScreen(
                        guide = A320Database.instrumentGuides[index],
                        onBack = { navController.popBackStack() }
                    )
                }
            }

            // FMGC
            composable("fmgc") {
                FMGCListScreen(
                    operations = A320Database.fmgcOperations,
                    onOperationClick = { op ->
                        val index = A320Database.fmgcOperations.indexOf(op)
                        navController.navigate("fmgc/$index")
                    }
                )
            }
            composable(
                "fmgc/{index}",
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                if (index < A320Database.fmgcOperations.size) {
                    FMGCDetailScreen(
                        operation = A320Database.fmgcOperations[index],
                        onBack = { navController.popBackStack() }
                    )
                }
            }

            // POH
            composable("poh") {
                POHListScreen(
                    sections = A320Database.pohSections,
                    onSectionClick = { section ->
                        val index = A320Database.pohSections.indexOf(section)
                        navController.navigate("poh/$index")
                    }
                )
            }
            composable(
                "poh/{index}",
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                if (index < A320Database.pohSections.size) {
                    POHDetailScreen(
                        section = A320Database.pohSections[index],
                        onBack = { navController.popBackStack() }
                    )
                }
            }
        }
    }
}
