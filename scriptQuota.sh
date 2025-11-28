#!/bin/bash

repquota -a | while read LINE; do

    if [ -z "$LINE" ]; then
        continue

    # Si la ligne commence un nouveau rapport, on saute les 5 lignes d'en-tête
    elif echo "$LINE" | grep -q "^\*\*\*"; then
        set -- $LINE
        PARTITION=$8
        TYPE=$4
        for i in $(seq 5); do
            read LINE
        done
        continue
    fi
    
    set -- $LINE
    NAME=$1
    USED=$2
    SOFT=$3
    HARD=$4
    GRACE=$5 

    if [ "$SOFT" -eq 0 ] && [ "$HARD" -eq 0 ]; then   # Ignorer si pas de limites
        continue
    fi

    if [ "$$HARD" -eq 0 ]; then
        pHARD=$(( USED * 100 / HARD ))
    fi

    # Déterminer destinataire du mail
    TARGET="$NAME"
    if [ "$TYPE" = "group" ]; then
        TARGET="root"
    fi

    # Alerte SOFT
    if [ "$GRACE" -gt 0 ]; then
        echo "$NAME utilise $USED/$SOFT de la limite sur la partition $PARTITION. Il reste $GRACE jours pour régler cela." \
            | mail -s "[Quota] Alerte SOFT $NAME" "$TARGET"
    fi

    # Alerte HARD
    if [ "$pHARD" -ge 80 ]; then
        echo "$NAME atteint $PCT_HARD% de la limite HARD sur la partition $PARTITION" \
        | mail -s "[Quota] Alerte HARD $NAME" "$TARGET"
    fi

done