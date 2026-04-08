package com.orchestrsim.a320guide.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
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
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Fill
import androidx.compose.ui.text.TextMeasurer
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.orchestrsim.a320guide.ui.theme.AppColors
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.tan

// MARK: - Visual Sight Picture Screen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun VisualSightPictureScreen() {
    var approachAngle by rememberSaveable { mutableFloatStateOf(3.0f) }
    var distanceNM by rememberSaveable { mutableFloatStateOf(3.0f) }
    var selectedPAPI by rememberSaveable { mutableStateOf(PAPIConfiguration.ON_GLIDESLOPE) }
    var showPAPIGuide by rememberSaveable { mutableStateOf(false) }
    var selectedVisualRef by rememberSaveable { mutableStateOf<VisualReference?>(null) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Visual Sight Picture") },
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
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            // Approach Angle Visualizer
            ApproachAngleSection(
                approachAngle = approachAngle,
                onAngleChange = { approachAngle = it },
                distanceNM = distanceNM,
                onDistanceChange = { distanceNM = it }
            )

            // PAPI Section
            PAPISection(
                selectedPAPI = selectedPAPI,
                onPAPISelect = { selectedPAPI = it },
                showGuide = showPAPIGuide,
                onToggleGuide = { showPAPIGuide = !showPAPIGuide }
            )

            // Visual Reference Points
            VisualReferenceSection(
                selectedRef = selectedVisualRef,
                onRefSelect = { ref ->
                    selectedVisualRef = if (selectedVisualRef == ref) null else ref
                }
            )

            // Runway Markings Guide
            RunwayCuesSection()

            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

// MARK: - Approach Angle Section

@Composable
private fun ApproachAngleSection(
    approachAngle: Float,
    onAngleChange: (Float) -> Unit,
    distanceNM: Float,
    onDistanceChange: (Float) -> Unit
) {
    val approachAngleColor = when {
        abs(approachAngle - 3.0f) < 0.3f -> AppColors.green
        approachAngle < 2.5f || approachAngle > 3.8f -> AppColors.red
        else -> AppColors.yellow
    }

    val textMeasurer = rememberTextMeasurer()

    Card(
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    Icons.Default.FlightLand,
                    contentDescription = null,
                    tint = AppColors.cyan
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    "Approach Profile",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Canvas approach visualization
            Canvas(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .clip(RoundedCornerShape(12.dp))
            ) {
                val width = size.width
                val height = size.height

                // Sky
                drawRect(
                    color = Color(0xFF1A237E).copy(alpha = 0.3f),
                    size = Size(width, height * 0.7f)
                )

                // Ground
                drawRect(
                    color = Color(0xFF1B5E20).copy(alpha = 0.2f),
                    topLeft = Offset(0f, height * 0.7f),
                    size = Size(width, height * 0.3f)
                )

                // Runway (perspective)
                val runwayStartX = width * 0.15f
                val runwayStartY = height * 0.7f
                val runwayWidth = 60f
                val perspectiveNarrow = max(5f, runwayWidth * (1 - distanceNM / 10f))

                val runwayPath = Path().apply {
                    moveTo(runwayStartX - runwayWidth / 2, runwayStartY)
                    lineTo(runwayStartX + runwayWidth / 2, runwayStartY)
                    lineTo(runwayStartX + perspectiveNarrow / 2, runwayStartY - 80f)
                    lineTo(runwayStartX - perspectiveNarrow / 2, runwayStartY - 80f)
                    close()
                }
                drawPath(runwayPath, Color.Gray.copy(alpha = 0.6f))

                // Centerline (dashed)
                drawLine(
                    color = Color.White.copy(alpha = 0.5f),
                    start = Offset(runwayStartX, runwayStartY),
                    end = Offset(runwayStartX, runwayStartY - 80f),
                    strokeWidth = 1f,
                    pathEffect = PathEffect.dashPathEffect(floatArrayOf(4f, 4f))
                )

                // 3 degree reference glideslope (dashed)
                val gsEndY = runwayStartY - 80f
                val gsEndX = runwayStartX
                val gsLength = width * 0.75f
                val refAngleRad = Math.toRadians(3.0).toFloat()
                val refStartX = gsEndX + gsLength
                val refStartY = gsEndY - gsLength * tan(refAngleRad)

                drawLine(
                    color = AppColors.green.copy(alpha = 0.4f),
                    start = Offset(gsEndX, gsEndY),
                    end = Offset(refStartX, refStartY),
                    strokeWidth = 1f,
                    pathEffect = PathEffect.dashPathEffect(floatArrayOf(6f, 4f))
                )

                // Actual approach line
                val actualAngleRad = Math.toRadians(approachAngle.toDouble()).toFloat()
                val actualStartY = gsEndY - gsLength * tan(actualAngleRad)

                drawLine(
                    color = approachAngleColor,
                    start = Offset(gsEndX, gsEndY),
                    end = Offset(refStartX, actualStartY),
                    strokeWidth = 2f
                )

                // Aircraft dot
                val distanceFraction = distanceNM / 10f
                val acX = gsEndX + gsLength * distanceFraction
                val acY = gsEndY - gsLength * distanceFraction * tan(actualAngleRad)

                drawCircle(
                    color = AppColors.cyan,
                    radius = 8f,
                    center = Offset(acX, acY)
                )

                // Altitude text
                val altFt = (distanceNM * 6076 * tan(actualAngleRad)).toInt()
                val altTextLayout = textMeasurer.measure(
                    "$altFt ft AGL",
                    TextStyle(
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        fontFamily = FontFamily.Monospace,
                        color = Color.White
                    )
                )
                drawText(
                    altTextLayout,
                    topLeft = Offset(
                        acX - altTextLayout.size.width / 2,
                        acY - 24f
                    )
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Angle slider
            Column {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Approach Angle", style = MaterialTheme.typography.bodySmall)
                    Text(
                        "%.1f\u00B0".format(approachAngle),
                        style = MaterialTheme.typography.bodySmall.copy(
                            fontFamily = FontFamily.Monospace,
                            fontWeight = FontWeight.Bold
                        ),
                        color = approachAngleColor
                    )
                }
                Slider(
                    value = approachAngle,
                    onValueChange = onAngleChange,
                    valueRange = 1.5f..5.0f,
                    steps = 34,
                    colors = SliderDefaults.colors(
                        thumbColor = approachAngleColor,
                        activeTrackColor = approachAngleColor
                    )
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Shallow", style = MaterialTheme.typography.labelSmall, color = AppColors.orange)
                    Text("3\u00B0 Standard", style = MaterialTheme.typography.labelSmall, color = AppColors.green)
                    Text("Steep", style = MaterialTheme.typography.labelSmall, color = AppColors.red)
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Distance slider
            Column {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Distance from Runway", style = MaterialTheme.typography.bodySmall)
                    Text(
                        "%.1f NM".format(distanceNM),
                        style = MaterialTheme.typography.bodySmall.copy(
                            fontFamily = FontFamily.Monospace,
                            fontWeight = FontWeight.Bold
                        ),
                        color = AppColors.cyan
                    )
                }
                Slider(
                    value = distanceNM,
                    onValueChange = onDistanceChange,
                    valueRange = 0.5f..10.0f,
                    steps = 18,
                    colors = SliderDefaults.colors(
                        thumbColor = AppColors.cyan,
                        activeTrackColor = AppColors.cyan
                    )
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Calculated values
            val actualAngleRad = Math.toRadians(approachAngle.toDouble()).toFloat()
            val altitudeFt = (distanceNM * 6076 * tan(actualAngleRad)).toInt()
            val descentRate = (tan(actualAngleRad) * 140 * 101.3).toInt()

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                InfoBadge(
                    label = "ALT",
                    value = "$altitudeFt ft",
                    color = AppColors.cyan,
                    modifier = Modifier.weight(1f)
                )
                InfoBadge(
                    label = "VS",
                    value = "$descentRate fpm",
                    color = AppColors.orange,
                    modifier = Modifier.weight(1f)
                )
                InfoBadge(
                    label = "GS",
                    value = "~140 kt",
                    color = AppColors.green,
                    modifier = Modifier.weight(1f)
                )
            }
        }
    }
}

// MARK: - PAPI Section

@Composable
private fun PAPISection(
    selectedPAPI: PAPIConfiguration,
    onPAPISelect: (PAPIConfiguration) -> Unit,
    showGuide: Boolean,
    onToggleGuide: () -> Unit
) {
    Card(
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Default.Highlight,
                        contentDescription = null,
                        tint = AppColors.cyan
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        "PAPI Interpretation",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold
                    )
                }
                IconButton(onClick = onToggleGuide) {
                    Icon(
                        Icons.Default.Info,
                        contentDescription = "Info",
                        tint = AppColors.cyan
                    )
                }
            }

            AnimatedVisibility(
                visible = showGuide,
                enter = fadeIn() + expandVertically(),
                exit = fadeOut() + shrinkVertically()
            ) {
                Text(
                    "PAPI (Precision Approach Path Indicator) uses 4 light units beside the runway. Red means you're below the light's transition angle; white means above.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(bottom = 12.dp)
                )
            }

            // PAPI configurations
            PAPIConfiguration.entries.forEach { config ->
                val isSelected = selectedPAPI == config
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp)
                        .clickable { onPAPISelect(config) },
                    colors = CardDefaults.cardColors(
                        containerColor = if (isSelected)
                            config.statusColor.copy(alpha = 0.1f)
                        else MaterialTheme.colorScheme.surface.copy(alpha = 0.5f)
                    ),
                    border = if (isSelected)
                        androidx.compose.foundation.BorderStroke(1.dp, config.statusColor.copy(alpha = 0.5f))
                    else null,
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // PAPI lights
                        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            config.lights.forEach { light ->
                                val lightColor = if (light == PAPILight.RED) Color.Red else Color.White
                                Box(
                                    modifier = Modifier
                                        .size(24.dp)
                                        .shadow(4.dp, CircleShape)
                                        .clip(CircleShape)
                                        .background(lightColor)
                                )
                            }
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                config.title,
                                style = MaterialTheme.typography.bodyMedium,
                                fontWeight = FontWeight.Bold,
                                color = config.statusColor
                            )
                            Text(
                                config.description,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                        if (isSelected) {
                            Icon(
                                Icons.Default.CheckCircle,
                                contentDescription = null,
                                tint = AppColors.cyan,
                                modifier = Modifier.size(20.dp)
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Action guidance
            Card(
                colors = CardDefaults.cardColors(
                    containerColor = selectedPAPI.statusColor.copy(alpha = 0.1f)
                ),
                shape = RoundedCornerShape(10.dp)
            ) {
                Row(
                    modifier = Modifier.padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        when (selectedPAPI) {
                            PAPIConfiguration.TOO_HIGH -> Icons.Default.ArrowDownward
                            PAPIConfiguration.SLIGHTLY_HIGH -> Icons.Default.ArrowDownward
                            PAPIConfiguration.ON_GLIDESLOPE -> Icons.Default.CheckCircle
                            PAPIConfiguration.SLIGHTLY_LOW -> Icons.Default.ArrowUpward
                            PAPIConfiguration.TOO_LOW -> Icons.Default.ArrowUpward
                        },
                        contentDescription = null,
                        tint = selectedPAPI.statusColor
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        selectedPAPI.action,
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Bold,
                        color = selectedPAPI.statusColor
                    )
                }
            }
        }
    }
}

// MARK: - Visual Reference Section

@Composable
private fun VisualReferenceSection(
    selectedRef: VisualReference?,
    onRefSelect: (VisualReference) -> Unit
) {
    Card(
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    Icons.Default.Visibility,
                    contentDescription = null,
                    tint = AppColors.cyan
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    "Visual Reference Points",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            VisualReference.entries.forEach { ref ->
                val isExpanded = selectedRef == ref

                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 3.dp)
                        .clickable { onRefSelect(ref) },
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.5f)
                    ),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                when (ref) {
                                    VisualReference.TEN_MILE -> Icons.Default.Flight
                                    VisualReference.FIVE_MILE -> Icons.Default.GpsFixed
                                    VisualReference.THREE_MILE -> Icons.Default.LocationOn
                                    VisualReference.ONE_MILE -> Icons.Default.ArrowDownward
                                    VisualReference.HALF_MILE -> Icons.Default.Warning
                                    VisualReference.THRESHOLD -> Icons.Default.LinearScale
                                    VisualReference.FLARE -> Icons.Default.FlightLand
                                },
                                contentDescription = null,
                                tint = ref.color,
                                modifier = Modifier.size(24.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    ref.title,
                                    style = MaterialTheme.typography.bodyMedium,
                                    fontWeight = FontWeight.Bold
                                )
                                Text(
                                    ref.distance,
                                    style = MaterialTheme.typography.labelSmall.copy(
                                        fontFamily = FontFamily.Monospace
                                    ),
                                    color = AppColors.cyan
                                )
                            }
                            Icon(
                                if (isExpanded) Icons.Default.KeyboardArrowUp
                                else Icons.Default.KeyboardArrowDown,
                                contentDescription = null,
                                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.size(18.dp)
                            )
                        }

                        AnimatedVisibility(
                            visible = isExpanded,
                            enter = fadeIn() + expandVertically(),
                            exit = fadeOut() + shrinkVertically()
                        ) {
                            Column(modifier = Modifier.padding(start = 32.dp, top = 8.dp)) {
                                Text(
                                    ref.description,
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                )

                                HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

                                Text(
                                    "What You Should See:",
                                    style = MaterialTheme.typography.labelMedium,
                                    fontWeight = FontWeight.Bold,
                                    color = AppColors.cyan
                                )
                                Spacer(modifier = Modifier.height(4.dp))

                                ref.visualCues.forEach { cue ->
                                    Row(
                                        modifier = Modifier.padding(vertical = 2.dp),
                                        verticalAlignment = Alignment.Top
                                    ) {
                                        Icon(
                                            Icons.Default.Visibility,
                                            contentDescription = null,
                                            tint = AppColors.cyan,
                                            modifier = Modifier
                                                .size(14.dp)
                                                .padding(top = 2.dp)
                                        )
                                        Spacer(modifier = Modifier.width(6.dp))
                                        Text(
                                            cue,
                                            style = MaterialTheme.typography.bodySmall,
                                            color = MaterialTheme.colorScheme.onSurfaceVariant
                                        )
                                    }
                                }

                                ref.pilotAction?.let { action ->
                                    HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                                    Row(verticalAlignment = Alignment.Top) {
                                        Icon(
                                            Icons.Default.PanTool,
                                            contentDescription = null,
                                            tint = AppColors.yellow,
                                            modifier = Modifier
                                                .size(14.dp)
                                                .padding(top = 2.dp)
                                        )
                                        Spacer(modifier = Modifier.width(6.dp))
                                        Text(
                                            action,
                                            style = MaterialTheme.typography.bodySmall.copy(
                                                fontWeight = FontWeight.Bold
                                            ),
                                            color = AppColors.yellow
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Runway Cues Section

@Composable
private fun RunwayCuesSection() {
    Card(
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    Icons.Default.LinearScale,
                    contentDescription = null,
                    tint = AppColors.cyan
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    "Runway Markings Guide",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Marking rows
            val markings = listOf(
                Triple("||||", "Threshold", "White stripes at runway start"),
                Triple("\u2588\u2588", "Aiming Point", "Two bold rectangles, ~300m from threshold"),
                Triple("== ==", "Touchdown Zone", "Symmetric stripe pairs, target landing area"),
                Triple("- - -", "Centerline", "Dashed line along runway center"),
                Triple("|   |", "Edge Markings", "Continuous white lines at runway edges")
            )

            markings.forEach { (marking, name, description) ->
                Row(
                    modifier = Modifier.padding(vertical = 6.dp, horizontal = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        marking,
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontFamily = FontFamily.Monospace,
                            fontWeight = FontWeight.Bold
                        ),
                        color = Color.White,
                        modifier = Modifier.width(50.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Column {
                        Text(
                            name,
                            style = MaterialTheme.typography.bodyMedium,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            description,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Approach lighting note
            Card(
                colors = CardDefaults.cardColors(
                    containerColor = AppColors.yellow.copy(alpha = 0.1f)
                ),
                shape = RoundedCornerShape(10.dp)
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            Icons.Default.Highlight,
                            contentDescription = null,
                            tint = AppColors.yellow
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            "Approach Lighting",
                            style = MaterialTheme.typography.bodyMedium,
                            fontWeight = FontWeight.Bold,
                            color = AppColors.yellow
                        )
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        "Most ILS-equipped runways have approach lighting (ALS/ALSF) extending up to 900m before the threshold. These provide visual guidance transitioning from instruments to visual references.",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

// MARK: - Info Badge

@Composable
private fun InfoBadge(
    label: String,
    value: String,
    color: Color,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier,
        colors = CardDefaults.cardColors(
            containerColor = color.copy(alpha = 0.1f)
        ),
        shape = RoundedCornerShape(8.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                label,
                style = MaterialTheme.typography.labelSmall.copy(
                    fontWeight = FontWeight.Bold
                ),
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Text(
                value,
                style = MaterialTheme.typography.bodySmall.copy(
                    fontFamily = FontFamily.Monospace,
                    fontWeight = FontWeight.Bold
                ),
                color = color
            )
        }
    }
}

// MARK: - PAPI Configuration Enum

enum class PAPILight {
    RED, WHITE
}

enum class PAPIConfiguration(
    val title: String,
    val description: String,
    val lights: List<PAPILight>,
    val statusColor: Color,
    val action: String
) {
    TOO_HIGH(
        title = "Too High",
        description = "All white \u2014 well above glideslope",
        lights = listOf(PAPILight.WHITE, PAPILight.WHITE, PAPILight.WHITE, PAPILight.WHITE),
        statusColor = AppColors.orange,
        action = "Increase rate of descent \u2014 reduce power"
    ),
    SLIGHTLY_HIGH(
        title = "Slightly High",
        description = "1 red, 3 white \u2014 slightly above",
        lights = listOf(PAPILight.RED, PAPILight.WHITE, PAPILight.WHITE, PAPILight.WHITE),
        statusColor = AppColors.yellow,
        action = "Minor correction \u2014 slight power reduction"
    ),
    ON_GLIDESLOPE(
        title = "On Glideslope (3\u00B0)",
        description = "2 red, 2 white \u2014 on glideslope",
        lights = listOf(PAPILight.RED, PAPILight.RED, PAPILight.WHITE, PAPILight.WHITE),
        statusColor = AppColors.green,
        action = "Maintain current approach path \u2014 stable"
    ),
    SLIGHTLY_LOW(
        title = "Slightly Low",
        description = "3 red, 1 white \u2014 slightly below",
        lights = listOf(PAPILight.RED, PAPILight.RED, PAPILight.RED, PAPILight.WHITE),
        statusColor = AppColors.yellow,
        action = "Minor correction \u2014 add slight power"
    ),
    TOO_LOW(
        title = "Too Low",
        description = "All red \u2014 well below glideslope",
        lights = listOf(PAPILight.RED, PAPILight.RED, PAPILight.RED, PAPILight.RED),
        statusColor = AppColors.red,
        action = "Increase power immediately \u2014 risk of undershoot"
    );
}

// MARK: - Visual Reference Enum

enum class VisualReference(
    val title: String,
    val distance: String,
    val color: Color,
    val description: String,
    val visualCues: List<String>,
    val pilotAction: String?
) {
    TEN_MILE(
        title = "10 NM \u2014 Initial Approach",
        distance = "~3,100 ft AGL",
        color = AppColors.blue,
        description = "Intercepting the glideslope. Runway may be visible in good weather as a thin line.",
        visualCues = listOf(
            "Runway may appear as a thin white/gray line",
            "Approach lights not yet individually distinguishable",
            "Terrain and landmarks for orientation",
            "PAPI not yet visible at most airports"
        ),
        pilotAction = "Configure aircraft, verify approach briefing complete"
    ),
    FIVE_MILE(
        title = "5 NM \u2014 Intermediate",
        distance = "~1,550 ft AGL",
        color = AppColors.cyan,
        description = "Established on approach. Runway shape becoming discernible. Configure flaps as appropriate.",
        visualCues = listOf(
            "Runway shape becoming rectangular",
            "Approach lighting system visible as a line of lights",
            "Surrounding taxiways and buildings becoming visible",
            "PAPI lights may become visible"
        ),
        pilotAction = "Final configuration \u2014 gear down, flaps set, checklist complete"
    ),
    THREE_MILE(
        title = "3 NM \u2014 Final Approach",
        distance = "~950 ft AGL",
        color = AppColors.green,
        description = "Stable approach should be established. Runway rectangle clearly visible with markings.",
        visualCues = listOf(
            "Runway clearly a rectangle \u2014 not a trapezoid (if on correct path)",
            "Threshold markings distinguishable",
            "PAPI clearly visible \u2014 check 2 red / 2 white",
            "Aiming point markings visible"
        ),
        pilotAction = "Confirm STABLE approach: speed, config, path, sink rate"
    ),
    ONE_MILE(
        title = "1 NM \u2014 Short Final",
        distance = "~320 ft AGL",
        color = AppColors.yellow,
        description = "Short final. Runway filling a significant portion of the windscreen. Detail visible.",
        visualCues = listOf(
            "Runway detail clear \u2014 centerline, edge markings",
            "Touchdown zone markings visible",
            "Aiming point filling significant windscreen area",
            "PAPI very prominent \u2014 use for fine glidepath control"
        ),
        pilotAction = "Call \"Runway in sight\" \u2014 crosscheck instruments vs visual"
    ),
    HALF_MILE(
        title = "0.5 NM \u2014 Decision Point",
        distance = "~160 ft AGL",
        color = AppColors.orange,
        description = "Decision height region for CAT I ILS. Must have visual references to continue.",
        visualCues = listOf(
            "Runway environment dominates forward view",
            "Individual runway edge lights clearly visible",
            "Able to assess surface condition (wet/dry)",
            "CAT I decision height: must see approach lights or runway"
        ),
        pilotAction = "At minimums: LAND or GO AROUND \u2014 no hesitation"
    ),
    THRESHOLD(
        title = "Threshold \u2014 Over the Piano Keys",
        distance = "~50 ft AGL",
        color = AppColors.red,
        description = "Crossing the threshold markings. Begin transition from approach to landing attitude.",
        visualCues = listOf(
            "Threshold (piano keys) passing below",
            "Aiming point ahead \u2014 do not land on threshold",
            "Runway width perspective confirms alignment",
            "Begin looking toward end of runway for pitch reference"
        ),
        pilotAction = "Retard thrust levers, begin flare"
    ),
    FLARE(
        title = "Flare \u2014 Touchdown",
        distance = "~15-30 ft AGL",
        color = AppColors.purple,
        description = "Pitch up gently to arrest descent. Look toward far end of runway for attitude reference.",
        visualCues = listOf(
            "Peripheral vision detects increasing closure rate with ground",
            "Far end of runway used for pitch attitude reference",
            "Runway edge lights rushing past peripherally",
            "Gentle pitch increase to 2-3\u00B0 above approach attitude"
        ),
        pilotAction = "RETARD callout \u2014 idle thrust, hold attitude, let it settle"
    );
}
