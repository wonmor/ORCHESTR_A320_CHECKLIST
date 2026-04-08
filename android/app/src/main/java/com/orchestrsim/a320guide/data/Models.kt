package com.orchestrsim.a320guide.data

import androidx.compose.ui.graphics.Color
import com.orchestrsim.a320guide.ui.theme.AppColors
import java.util.UUID

// MARK: - Checklist Models

data class ChecklistItem(
    val id: String = UUID.randomUUID().toString(),
    val challenge: String,
    val response: String,
    val notes: String? = null,
    var isCompleted: Boolean = false
)

data class Checklist(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val subtitle: String,
    val icon: String,
    val phase: FlightPhase,
    val items: MutableList<ChecklistItem>,
    val color: Color = AppColors.blue
)

enum class FlightPhase(val displayName: String, val icon: String, val color: Color) {
    PREFLIGHT("Pre-Flight", "build", AppColors.blue),
    TAXI("Taxi", "directions_car", AppColors.cyan),
    TAKEOFF("Takeoff", "flight_takeoff", AppColors.green),
    CLIMB("Climb", "trending_up", AppColors.mint),
    CRUISE("Cruise", "flight", AppColors.indigo),
    DESCENT("Descent", "trending_down", AppColors.orange),
    APPROACH("Approach", "gps_fixed", AppColors.yellow),
    LANDING("Landing", "flight_land", AppColors.red),
    POST_FLIGHT("Post-Flight", "local_parking", AppColors.purple);
}

// MARK: - Emergency Procedure Models

data class EmergencyProcedure(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val subtitle: String,
    val severity: EmergencySeverity,
    val icon: String,
    val memoryItems: List<String> = emptyList(),
    val steps: List<ProcedureStep>,
    val notes: List<String> = emptyList()
)

data class ProcedureStep(
    val id: String = UUID.randomUUID().toString(),
    val action: String,
    val detail: String? = null,
    val isConditional: Boolean = false,
    val condition: String? = null,
    var isCompleted: Boolean = false
)

enum class EmergencySeverity(val displayName: String, val color: Color, val icon: String) {
    WARNING("WARNING", AppColors.red, "warning"),
    CAUTION("CAUTION", AppColors.orange, "error"),
    ADVISORY("ADVISORY", AppColors.yellow, "info");
}

// MARK: - Instrument Guide Models

data class InstrumentGuide(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val abbreviation: String,
    val description: String,
    val icon: String,
    val location: String,
    val sections: List<InstrumentSection>,
    val color: Color = AppColors.blue
)

data class InstrumentSection(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val items: List<InstrumentDetail>
)

data class InstrumentDetail(
    val id: String = UUID.randomUUID().toString(),
    val label: String,
    val description: String,
    val color: String? = null
)

// MARK: - Approach Procedure Models

data class ApproachProcedure(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val type: ApproachType,
    val icon: String,
    val description: String,
    val minimums: String,
    val requiredEquipment: List<String>,
    val steps: List<ProcedureStep>,
    val fmgcSetup: List<String> = emptyList(),
    val notes: List<String> = emptyList()
)

enum class ApproachType(val displayName: String, val color: Color) {
    ILS("ILS", AppColors.green),
    VOR("VOR", AppColors.blue),
    VOR_DME("VOR/DME", AppColors.cyan),
    NDB("NDB", AppColors.orange),
    RNAV("RNAV (GPS)", AppColors.purple),
    VISUAL("Visual", AppColors.yellow),
    CIRCLING("Circling", AppColors.mint),
    LOC("LOC Only", AppColors.teal);
}

// MARK: - FMGC Models

data class FMGCOperation(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val subtitle: String,
    val icon: String,
    val mcduPage: String,
    val steps: List<FMGCStep>,
    val tips: List<String> = emptyList(),
    val color: Color = AppColors.cyan
)

data class FMGCStep(
    val id: String = UUID.randomUUID().toString(),
    val keyPress: String,
    val action: String,
    val display: String? = null
)

// MARK: - POH Models

data class POHSection(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val icon: String,
    val subsections: List<POHSubsection>,
    val color: Color = AppColors.indigo
)

data class POHSubsection(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val content: List<POHEntry>
)

data class POHEntry(
    val id: String = UUID.randomUUID().toString(),
    val parameter: String,
    val value: String,
    val unit: String? = null,
    val note: String? = null
)

// MARK: - Quiz Models

data class QuizQuestion(
    val id: String = UUID.randomUUID().toString(),
    val question: String,
    val choices: List<String>,
    val correctIndex: Int,
    val category: QuizCategory,
    val explanation: String
)

enum class QuizCategory(val displayName: String, val icon: String, val color: Color) {
    CHECKLISTS("Checklists", "checklist", AppColors.cyan),
    EMERGENCY("Emergency", "warning", AppColors.red),
    APPROACHES("Approaches", "gps_fixed", AppColors.green),
    SYSTEMS("Systems", "settings", AppColors.indigo),
    LIMITATIONS("Limitations", "speed", AppColors.orange);
}
