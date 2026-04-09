package com.orchestrsim.a320guide

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.orchestrsim.a320guide.data.ChecklistStore
import com.orchestrsim.a320guide.ui.navigation.AppNavigation
import com.orchestrsim.a320guide.ui.theme.A320GuideTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ChecklistStore.initialize(this)
        enableEdgeToEdge()
        setContent {
            A320GuideTheme {
                AppNavigation()
            }
        }
    }
}
