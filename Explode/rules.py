def check_disarm(wires, index, serial_number):
    num_wires = len(wires)
    last_digit_is_odd = int(serial_number[-1]) % 2 == 1

    if num_wires == 3:
        # Règles pour 3 câbles
        if "rouge" not in wires:
            return index == 1  # Couper le deuxième câble
        elif wires[-1] == "blanc":
            return index == len(wires) - 1  # Couper le dernier câble
        elif wires.count("bleu") > 1:
            last_blue = len(wires) - 1 - wires[::-1].index("bleu")
            return index == last_blue  # Couper le dernier câble bleu
        else:
            return index == len(wires) - 1  # Couper le dernier câble

    elif num_wires == 4:
        # Règles pour 4 câbles
        if wires.count("rouge") > 1 and last_digit_is_odd:
            last_red = len(wires) - 1 - wires[::-1].index("rouge")
            return index == last_red  # Couper le dernier câble rouge
        elif wires[-1] == "jaune" and "rouge" not in wires:
            return index == 0  # Couper le premier câble
        elif wires.count("bleu") == 1:
            return index == 0  # Couper le premier câble
        elif wires.count("jaune") > 1:
            return index == len(wires) - 1  # Couper le dernier câble
        else:
            return index == 1  # Couper le deuxième câble

    elif num_wires == 5:
        # Règles pour 5 câbles
        if wires[-1] == "noir" and last_digit_is_odd:
            return index == 3  # Couper le quatrième câble
        elif wires.count("rouge") == 1 and wires.count("jaune") > 1:
            return index == 0  # Couper le premier câble
        elif "noir" not in wires:
            return index == 1  # Couper le deuxième câble
        else:
            return index == 0  # Couper le premier câble

    elif num_wires == 6:
        # Règles pour 6 câbles
        if "jaune" not in wires and last_digit_is_odd:
            return index == 2  # Couper le troisième câble
        elif wires.count("jaune") == 1 and wires.count("blanc") > 1:
            return index == 3  # Couper le quatrième câble
        elif "rouge" not in wires:
            return index == len(wires) - 1  # Couper le dernier câble
        else:
            return index == 3  # Couper le quatrième câble

    # Par sécurité, on renvoie False si les règles ne correspondent à aucun cas.
    return False
