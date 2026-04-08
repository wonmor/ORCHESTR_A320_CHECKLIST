package com.orchestrsim.a320guide.data

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.snapshots.SnapshotStateList

object ChecklistStore {
    private const val PREFS_NAME = "checklist_prefs"
    private var prefs: SharedPreferences? = null

    val checklists: SnapshotStateList<Checklist> = mutableStateListOf()

    fun initialize(context: Context) {
        prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        checklists.clear()
        // Deep copy from database so we can mutate
        A320Database.normalChecklists.forEach { checklist ->
            checklists.add(
                checklist.copy(
                    items = checklist.items.map { it.copy() }.toMutableList()
                )
            )
        }
        loadState()
    }

    fun toggleItem(checklistIndex: Int, itemIndex: Int) {
        val item = checklists[checklistIndex].items[itemIndex]
        checklists[checklistIndex].items[itemIndex] = item.copy(isCompleted = !item.isCompleted)
        // Force recomposition by replacing the checklist
        val updated = checklists[checklistIndex].copy(
            items = checklists[checklistIndex].items.toMutableList()
        )
        checklists[checklistIndex] = updated
        saveState()
    }

    fun completeAll(checklistIndex: Int) {
        val updated = checklists[checklistIndex].copy(
            items = checklists[checklistIndex].items.map { it.copy(isCompleted = true) }.toMutableList()
        )
        checklists[checklistIndex] = updated
        saveState()
    }

    fun resetChecklist(checklistIndex: Int) {
        val updated = checklists[checklistIndex].copy(
            items = checklists[checklistIndex].items.map { it.copy(isCompleted = false) }.toMutableList()
        )
        checklists[checklistIndex] = updated
        saveState()
    }

    private fun saveState() {
        val editor = prefs?.edit() ?: return
        checklists.forEach { checklist ->
            checklist.items.forEach { item ->
                editor.putBoolean("${checklist.title}|${item.challenge}", item.isCompleted)
            }
        }
        editor.apply()
    }

    private fun loadState() {
        val p = prefs ?: return
        checklists.forEachIndexed { ci, checklist ->
            val updatedItems = checklist.items.mapIndexed { ii, item ->
                val key = "${checklist.title}|${item.challenge}"
                val completed = p.getBoolean(key, false)
                if (completed != item.isCompleted) item.copy(isCompleted = completed) else item
            }.toMutableList()
            checklists[ci] = checklist.copy(items = updatedItems)
        }
    }
}
