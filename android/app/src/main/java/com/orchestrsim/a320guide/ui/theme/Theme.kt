package com.orchestrsim.a320guide.ui.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

val Cyan = Color(0xFF00BCD4)
val CyanDark = Color(0xFF0097A7)
val DarkBackground = Color(0xFF121212)
val DarkSurface = Color(0xFF1E1E1E)
val DarkSurfaceVariant = Color(0xFF2C2C2C)

private val DarkColorScheme = darkColorScheme(
    primary = Cyan,
    onPrimary = Color.Black,
    primaryContainer = CyanDark,
    secondary = Color(0xFF03DAC6),
    tertiary = Color(0xFFBB86FC),
    background = DarkBackground,
    surface = DarkSurface,
    surfaceVariant = DarkSurfaceVariant,
    onBackground = Color.White,
    onSurface = Color.White,
    onSurfaceVariant = Color(0xFFCACACA),
    error = Color(0xFFCF6679),
)

@Composable
fun A320GuideTheme(content: @Composable () -> Unit) {
    val colorScheme = DarkColorScheme
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = Color.Black.toArgb()
            window.navigationBarColor = Color.Black.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = false
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography(),
        content = content
    )
}

// App color constants matching iOS
object AppColors {
    val cyan = Color(0xFF00BCD4)
    val green = Color(0xFF4CAF50)
    val red = Color(0xFFF44336)
    val orange = Color(0xFFFF9800)
    val yellow = Color(0xFFFFEB3B)
    val blue = Color(0xFF2196F3)
    val indigo = Color(0xFF3F51B5)
    val purple = Color(0xFF9C27B0)
    val mint = Color(0xFF26A69A)
    val teal = Color(0xFF009688)
    val pink = Color(0xFFE91E63)
    val gray = Color(0xFF9E9E9E)
}
