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
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.*
import androidx.navigation.navArgument
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

sealed class Screen(val route: String) {
    data object ChecklistList : Screen("checklists")
    data object ChecklistDetail : Screen("checklist/{index}") {
        fun createRoute(index: Int) = "checklist/$index"
    }
    data object EmergencyList : Screen("emergency")
    data object EmergencyDetail : Screen("emergency/{index}") {
        fun createRoute(index: Int) = "emergency/$index"
    }
    data object VisualSightPicture : Screen("visual")
    data object ApproachList : Screen("approaches")
    data object ApproachDetail : Screen("approach/{index}") {
        fun createRoute(index: Int) = "approach/$index"
    }
    data object Quiz : Screen("quiz")
    data object InstrumentList : Screen("instruments")
    data object InstrumentDetail : Screen("instrument/{index}") {
        fun createRoute(index: Int) = "instrument/$index"
    }
    data object FMGCList : Screen("fmgc")
    data object FMGCDetail : Screen("fmgc/{index}") {
        fun createRoute(index: Int) = "fmgc/$index"
    }
    data object POHList : Screen("poh")
    data object POHDetail : Screen("poh/{index}") {
        fun createRoute(index: Int) = "poh/$index"
    }
    data object More : Screen("more")
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    var selectedTab by rememberSaveable { mutableStateOf(AppTab.CHECKLISTS) }

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
                            selectedTab = tab
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
            startDestination = Screen.ChecklistList.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            // Checklists
            composable(Screen.ChecklistList.route) {
                ChecklistCategoryScreen(
                    onChecklistClick = { index ->
                        navController.navigate(Screen.ChecklistDetail.createRoute(index))
                    }
                )
            }
            composable(
                Screen.ChecklistDetail.route,
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                ChecklistDetailScreen(
                    checklistIndex = index,
                    onBack = { navController.popBackStack() }
                )
            }

            // Emergency
            composable(Screen.EmergencyList.route) {
                EmergencyListScreen(
                    onProcedureClick = { index ->
                        navController.navigate(Screen.EmergencyDetail.createRoute(index))
                    }
                )
            }
            composable(
                Screen.EmergencyDetail.route,
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                EmergencyDetailScreen(
                    procedureIndex = index,
                    onBack = { navController.popBackStack() }
                )
            }

            // Visual Sight Picture
            composable(Screen.VisualSightPicture.route) {
                VisualSightPictureScreen()
            }

            // Approaches
            composable(Screen.ApproachList.route) {
                ApproachListScreen(
                    onApproachClick = { index ->
                        navController.navigate(Screen.ApproachDetail.createRoute(index))
                    }
                )
            }
            composable(
                Screen.ApproachDetail.route,
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                ApproachDetailScreen(
                    procedureIndex = index,
                    onBack = { navController.popBackStack() }
                )
            }

            // Quiz
            composable(Screen.Quiz.route) {
                QuizScreen()
            }

            // More
            composable(Screen.More.route) {
                MoreScreen(
                    onInstrumentsClick = { navController.navigate(Screen.InstrumentList.route) },
                    onFMGCClick = { navController.navigate(Screen.FMGCList.route) },
                    onPOHClick = { navController.navigate(Screen.POHList.route) }
                )
            }

            // Instruments
            composable(Screen.InstrumentList.route) {
                InstrumentListScreen(
                    onGuideClick = { index ->
                        navController.navigate(Screen.InstrumentDetail.createRoute(index))
                    },
                    onBack = { navController.popBackStack() }
                )
            }
            composable(
                Screen.InstrumentDetail.route,
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                InstrumentDetailScreen(
                    guideIndex = index,
                    onBack = { navController.popBackStack() }
                )
            }

            // FMGC
            composable(Screen.FMGCList.route) {
                FMGCListScreen(
                    onOperationClick = { index ->
                        navController.navigate(Screen.FMGCDetail.createRoute(index))
                    },
                    onBack = { navController.popBackStack() }
                )
            }
            composable(
                Screen.FMGCDetail.route,
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                FMGCDetailScreen(
                    operationIndex = index,
                    onBack = { navController.popBackStack() }
                )
            }

            // POH
            composable(Screen.POHList.route) {
                POHListScreen(
                    onSectionClick = { index ->
                        navController.navigate(Screen.POHDetail.createRoute(index))
                    },
                    onBack = { navController.popBackStack() }
                )
            }
            composable(
                Screen.POHDetail.route,
                arguments = listOf(navArgument("index") { type = NavType.IntType })
            ) { backStackEntry ->
                val index = backStackEntry.arguments?.getInt("index") ?: 0
                POHDetailScreen(
                    sectionIndex = index,
                    onBack = { navController.popBackStack() }
                )
            }
        }
    }
}
