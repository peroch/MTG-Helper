//
//  UserPreferencesService.swift
//  MTG Helper
//
//  Gestion centralisée des préférences utilisateur via UserDefaults.
//

import Foundation

/// Preference keys used in UserDefaults.
enum PreferenceKey: String {
    case deckListDisplayMode = "deck_list_display_mode"
    case searchCardDisplayMode = "search_card_display_mode"
    case deckCardDisplayMode = "deck_card_display_mode"
    case lastUsedDeckFormat = "last_used_deck_format"
    case showManaSymbols = "show_mana_symbols"
}

/// Display mode for deck list.
enum DeckListDisplayMode: String, Codable {
    case list
    case grid
    
    var displayName: String {
        switch self {
        case .list: return "List"
        case .grid: return "Grid"
        }
    }
}

/// Display mode for search card list.
enum SearchCardDisplayMode: String, Codable {
    case detailed
    case compact
    
    var displayName: String {
        switch self {
        case .detailed: return "Detailed"
        case .compact: return "Compact"
        }
    }
}

/// Display mode for deck card list.
enum DeckCardDisplayMode: String, Codable {
    case detailed
    case compact
    
    var displayName: String {
        switch self {
        case .detailed: return "Detailed"
        case .compact: return "Compact"
        }
    }
}

/// Service de gestion des préférences utilisateur.
/// Centralise tous les accès à UserDefaults pour garantir une cohérence.
final class UserPreferencesService {
    
    // MARK: - Properties
    
    private let userDefaults: UserDefaults
    
    // MARK: - Singleton
    
    static let shared = UserPreferencesService()
    
    // MARK: - Initialization
    
    /// Initialise le service avec les UserDefaults standard.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Deck Display Mode
    
    /// Mode d'affichage actuel pour la liste de decks.
    var deckListDisplayMode: DeckListDisplayMode {
        get {
            guard let rawValue = userDefaults.string(forKey: PreferenceKey.deckListDisplayMode.rawValue),
                  let mode = DeckListDisplayMode(rawValue: rawValue) else {
                return .list // Valeur par défaut
            }
            return mode
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: PreferenceKey.deckListDisplayMode.rawValue)
        }
    }
    
    // MARK: - Search Card Display Mode
    
    /// Current display mode for search card list.
    var searchCardDisplayMode: SearchCardDisplayMode {
        get {
            guard let rawValue = userDefaults.string(forKey: PreferenceKey.searchCardDisplayMode.rawValue),
                  let mode = SearchCardDisplayMode(rawValue: rawValue) else {
                return .detailed
            }
            return mode
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: PreferenceKey.searchCardDisplayMode.rawValue)
        }
    }
    
    // MARK: - Deck Card Display Mode
    
    /// Current display mode for deck card list.
    var deckCardDisplayMode: DeckCardDisplayMode {
        get {
            guard let rawValue = userDefaults.string(forKey: PreferenceKey.deckCardDisplayMode.rawValue),
                  let mode = DeckCardDisplayMode(rawValue: rawValue) else {
                return .detailed
            }
            return mode
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: PreferenceKey.deckCardDisplayMode.rawValue)
        }
    }
    
    // MARK: - Last Used Deck Format
    
    /// Dernier format de deck utilisé.
    var lastUsedDeckFormat: String? {
        get {
            userDefaults.string(forKey: PreferenceKey.lastUsedDeckFormat.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: PreferenceKey.lastUsedDeckFormat.rawValue)
        }
    }
    
    // MARK: - Mana Symbols Display
    
    /// Indique si les symboles de mana doivent être affichés.
    var showManaSymbols: Bool {
        get {
            // Si la clé n'existe pas, retourner true par défaut
            if userDefaults.object(forKey: PreferenceKey.showManaSymbols.rawValue) == nil {
                return true
            }
            return userDefaults.bool(forKey: PreferenceKey.showManaSymbols.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: PreferenceKey.showManaSymbols.rawValue)
        }
    }
    
    // MARK: - Reset
    
    /// Resets all preferences to their default values.
    func resetToDefaults() {
        userDefaults.removeObject(forKey: PreferenceKey.deckListDisplayMode.rawValue)
        userDefaults.removeObject(forKey: PreferenceKey.searchCardDisplayMode.rawValue)
        userDefaults.removeObject(forKey: PreferenceKey.deckCardDisplayMode.rawValue)
        userDefaults.removeObject(forKey: PreferenceKey.lastUsedDeckFormat.rawValue)
        userDefaults.removeObject(forKey: PreferenceKey.showManaSymbols.rawValue)
    }
}
