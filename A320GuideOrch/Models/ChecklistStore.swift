import SwiftUI

// MARK: - Checklist Persistence Store

@Observable
class ChecklistStore {
    var checklists: [Checklist]

    private let saveKey = "savedChecklistState"

    init() {
        self.checklists = A320Database.normalChecklists
        loadState()
    }

    func saveState() {
        // Save completion state as dictionary of challenge -> isCompleted
        var state: [String: Bool] = [:]
        for checklist in checklists {
            for item in checklist.items {
                let key = "\(checklist.title)|\(item.challenge)"
                state[key] = item.isCompleted
            }
        }
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func loadState() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let state = try? JSONDecoder().decode([String: Bool].self, from: data) else {
            return
        }

        for ci in checklists.indices {
            for ii in checklists[ci].items.indices {
                let key = "\(checklists[ci].title)|\(checklists[ci].items[ii].challenge)"
                if let completed = state[key] {
                    checklists[ci].items[ii].isCompleted = completed
                }
            }
        }
    }

    func resetAll() {
        for ci in checklists.indices {
            for ii in checklists[ci].items.indices {
                checklists[ci].items[ii].isCompleted = false
            }
        }
        saveState()
    }

    func toggleItem(checklistIndex: Int, itemIndex: Int) {
        checklists[checklistIndex].items[itemIndex].isCompleted.toggle()
        saveState()
    }

    func completeAll(checklistIndex: Int) {
        for ii in checklists[checklistIndex].items.indices {
            checklists[checklistIndex].items[ii].isCompleted = true
        }
        saveState()
    }

    func resetChecklist(checklistIndex: Int) {
        for ii in checklists[checklistIndex].items.indices {
            checklists[checklistIndex].items[ii].isCompleted = false
        }
        saveState()
    }
}
