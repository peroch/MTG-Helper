#!/usr/bin/env bash

###
### Script d'analyse des coûts d'utilisation de Cline
### Auteur: Généré pour MTG Helper
### Usage: ./cline_costs.sh [today|week|month|year|life] [--verbose]
###

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Répertoires Cline
CLINE_DIR="$HOME/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/tasks"
TASK_HISTORY_FILE="$HOME/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/state/taskHistory.json"

# Tarifs en USD pour 1M tokens (input et output)
# Format: "model_id:input_cost:output_cost"
MODEL_COSTS=(
    "anthropic/claude-sonnet-4.5:3.00:15.00"
    "anthropic/claude-3-5-sonnet-20241022:3.00:15.00"
    "anthropic/claude-3-opus:15.00:75.00"
    "anthropic/claude-3-sonnet:3.00:15.00"
    "anthropic/claude-3-haiku:0.25:1.25"
)

# Variables globales
VERBOSE=false
PERIOD=""
TOTAL_COST=0
TOTAL_REQUESTS=0
TOTAL_INPUT_TOKENS=0
TOTAL_OUTPUT_TOKENS=0

###
### Affiche l'aide
###
show_help() {
    echo -e "${CYAN}Usage:${NC} $0 [PERIOD] [--verbose]"
    echo ""
    echo "Périodes disponibles:"
    echo "  today   - Coûts de la journée en cours"
    echo "  week    - Coûts de la semaine en cours"
    echo "  month   - Coûts du mois en cours"
    echo "  year    - Coûts de l'année en cours"
    echo "  life    - Coûts total depuis le début"
    echo ""
    echo "Options:"
    echo "  --verbose  Affiche le détail de chaque requête et réponse"
    echo ""
    echo "Exemple: $0 week --verbose"
}

###
### Calcule le timestamp de début selon la période
###
get_start_timestamp() {
    local period=$1
    local now=$(date +%s)
    
    case $period in
        "today")
            date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%Y-%m-%d) 00:00:00" +%s 2>/dev/null || echo 0
            ;;
        "week")
            local day_of_week=$(date +%u)
            local days_since_monday=$((day_of_week - 1))
            echo $(( (now - (days_since_monday * 86400)) - ($(date +%H) * 3600) - ($(date +%M) * 60) - $(date +%S) ))
            ;;
        "month")
            date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%Y-%m-01) 00:00:00" +%s 2>/dev/null || echo 0
            ;;
        "year")
            date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%Y-01-01) 00:00:00" +%s 2>/dev/null || echo 0
            ;;
        "life")
            echo 0
            ;;
        *)
            echo 0
            ;;
    esac
}

###
### Estime le nombre de tokens dans un texte
### Approximation: ~4 caractères par token
###
estimate_tokens() {
    local text=$1
    local char_count=$(echo -n "$text" | wc -c | tr -d ' ')
    echo $((char_count / 4))
}

###
### Récupère les vraies métriques depuis taskHistory.json
###
get_task_metrics() {
    local task_id=$1
    
    if [ ! -f "$TASK_HISTORY_FILE" ]; then
        echo "0:0:0.0000"
        return
    fi
    
    local metrics=$(jq -r ".[] | select(.id == \"$task_id\") | \"\(.tokensIn // 0):\(.tokensOut // 0):\(.totalCost // 0)\"" "$TASK_HISTORY_FILE" 2>/dev/null)
    
    if [ -z "$metrics" ] || [ "$metrics" = "null" ]; then
        echo "0:0:0.0000"
    else
        echo "$metrics"
    fi
}

###
### Extrait et affiche les informations d'une conversation
###
process_conversation() {
    local api_history=$1
    local ui_messages=$2
    local task_id=$3
    
    if [ ! -f "$api_history" ]; then
        return
    fi
    
    # Récupère les vraies métriques depuis taskHistory.json
    local metrics=$(get_task_metrics "$task_id")
    IFS=':' read -r task_input_tokens task_output_tokens task_cost <<< "$metrics"
    
    # Si on n'a pas de métriques, on skip cette tâche
    if [ "$task_input_tokens" -eq 0 ] && [ "$task_output_tokens" -eq 0 ]; then
        return
    fi
    
    TOTAL_REQUESTS=$((TOTAL_REQUESTS + 1))
    TOTAL_INPUT_TOKENS=$((TOTAL_INPUT_TOKENS + task_input_tokens))
    TOTAL_OUTPUT_TOKENS=$((TOTAL_OUTPUT_TOKENS + task_output_tokens))
    
    # Addition du coût (gestion des nombres décimaux)
    if [ "$TOTAL_COST" = "0" ]; then
        TOTAL_COST="$task_cost"
    else
        TOTAL_COST=$(awk "BEGIN {printf \"%.4f\", $TOTAL_COST + $task_cost}")
    fi
    
    if $VERBOSE; then
        # Affiche le détail des messages
        local msg_count=$(jq 'length' "$api_history" 2>/dev/null || echo 0)
        
        for i in $(seq 0 $((msg_count - 1))); do
            local role=$(jq -r ".[$i].role" "$api_history" 2>/dev/null || echo "")
            local content=$(jq -r ".[$i].content[0].text // .[$i].content // \"\"" "$api_history" 2>/dev/null || echo "")
            
            if [ -z "$content" ] || [ "$content" = "null" ]; then
                continue
            fi
            
            echo -e "\n${BLUE}[$role]${NC}"
            echo "---"
            echo "$content" | head -n 20
            if [ $(echo "$content" | wc -l) -gt 20 ]; then
                echo -e "${YELLOW}... (contenu tronqué)${NC}"
            fi
            echo "---"
        done
        
        echo -e "\n${MAGENTA}Coût de cette tâche:${NC} \$${task_cost} (${task_input_tokens} tokens in, ${task_output_tokens} tokens out)"
        echo ""
    fi
}

###
### Fonction principale
###
main() {
    # Parse des arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose)
                VERBOSE=true
                shift
                ;;
            today|week|month|year|life)
                PERIOD=$1
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}Erreur:${NC} Argument inconnu: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Vérifie qu'une période est spécifiée
    if [ -z "$PERIOD" ]; then
        echo -e "${RED}Erreur:${NC} Vous devez spécifier une période"
        show_help
        exit 1
    fi
    
    # Vérifie que le répertoire Cline existe
    if [ ! -d "$CLINE_DIR" ]; then
        echo -e "${RED}Erreur:${NC} Répertoire Cline introuvable: $CLINE_DIR"
        exit 1
    fi
    
    # Calcule le timestamp de début
    local start_ts=$(get_start_timestamp "$PERIOD")
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Analyse des coûts Cline - Période: ${YELLOW}$PERIOD${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Collecte les IDs des tâches dans la période
    local task_ids=()
    
    # Parcourt tous les dossiers de tâches
    for task_dir in "$CLINE_DIR"/*; do
        if [ -d "$task_dir" ]; then
            local task_id=$(basename "$task_dir")
            local task_ts=$((task_id / 1000))  # Convertit millisecondes en secondes
            
            # Vérifie si la tâche est dans la période demandée
            if [ $task_ts -ge $start_ts ]; then
                task_ids+=("$task_id")
                
                local api_history="$task_dir/api_conversation_history.json"
                local ui_messages="$task_dir/ui_messages.json"
                
                if $VERBOSE; then
                    echo -e "${GREEN}━━━ Tâche: $task_id ($(date -r $task_ts '+%Y-%m-%d %H:%M:%S')) ━━━${NC}"
                fi
                
                process_conversation "$api_history" "$ui_messages" "$task_id"
            fi
        fi
    done
    
    # Calcule le coût total avec jq directement depuis taskHistory.json
    if [ ${#task_ids[@]} -gt 0 ]; then
        # Construit le filtre jq pour sommer uniquement les tâches de la période
        local jq_filter='[.[] | select('
        for i in "${!task_ids[@]}"; do
            if [ $i -eq 0 ]; then
                jq_filter+="(.id == \"${task_ids[$i]}\")"
            else
                jq_filter+=" or (.id == \"${task_ids[$i]}\")"
            fi
        done
        jq_filter+=') | .totalCost // 0] | add // 0'
        
        TOTAL_COST=$(jq "$jq_filter" "$TASK_HISTORY_FILE" 2>/dev/null)
        if [ ! -z "$TOTAL_COST" ] && [ "$TOTAL_COST" != "null" ]; then
            TOTAL_COST=$(awk "BEGIN {printf \"%.4f\", $TOTAL_COST}")
        else
            TOTAL_COST="0.0000"
        fi
    fi
    
    # Affiche le résumé
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  RÉSUMÉ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "Période:                ${YELLOW}$PERIOD${NC}"
    echo -e "Nombre de tâches:       ${YELLOW}$TOTAL_REQUESTS${NC}"
    echo -e "Tokens en entrée:       ${YELLOW}$TOTAL_INPUT_TOKENS${NC}"
    echo -e "Tokens en sortie:       ${YELLOW}$TOTAL_OUTPUT_TOKENS${NC}"
    echo -e "Coût total:             ${YELLOW}\$${TOTAL_COST}${NC}"
    echo ""
    echo -e "${CYAN}Note:${NC} Les valeurs affichées sont les ${YELLOW}coûts réels${NC} enregistrés par Cline"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
}

# Exécute le script
main "$@"
