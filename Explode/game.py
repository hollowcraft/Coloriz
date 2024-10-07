import random

class BombGameLogic:
    def __init__(self):
        self.module_type = 'wires'
        # self.module_type = random.choice(['wires', 'button'])  # Choisir aléatoirement entre câbles et boutons
        self.wires_module1 = []
        self.wires_module2 = []
        self.button_color = None
        self.button_label = None
        self.serial_number = self.generate_serial_number()
        self.batteries = random.randint(1, 4)  # Nombre aléatoire de batteries pour la démonstration
        self.lit_indicators = ['CAR', 'FRK']  # Pour les tests, on peut définir quelles indications sont allumées
        self.generate_modules()

    def generate_serial_number(self):
        return ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', k=5) + random.choices('0123456789', k=1))

    def generate_modules(self):
        if self.module_type == 'wires':
            num_wires1 = random.randint(3, 6)
            num_wires2 = random.randint(3, 6)
            colors = ["rouge", "bleu", "jaune", "noir", "blanc"]
            self.wires_module1 = [random.choice(colors) for _ in range(num_wires1)]
            self.wires_module2 = [random.choice(colors) for _ in range(num_wires2)]
        elif self.module_type == 'button':
            colors = ["bleu", "blanc", "jaune", "rouge"]
            labels = ["Abort", "Detonate", "Hold"]
            self.button_color = random.choice(colors)
            self.button_label = random.choice(labels)

    def last_digit_is_odd(self):
        last_char = self.serial_number[-1]
        if last_char.isdigit():
            return int(last_char) % 2 == 1
        else:
            return False

    def check_disarm_wire(self, module, index):
        if module == 1:
            wires = self.wires_module1
        else:
            wires = self.wires_module2

        num_wires = len(wires)

        if num_wires == 3:
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
            if wires.count("rouge") > 1 and self.last_digit_is_odd():
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
            if wires[-1] == "noir" and self.last_digit_is_odd():
                return index == 3  # Couper le quatrième câble
            elif wires.count("rouge") == 1 and wires.count("jaune") > 1:
                return index == 0  # Couper le premier câble
            elif "noir" not in wires:
                return index == 1  # Couper le deuxième câble
            else:
                return index == 0  # Couper le premier câble

        elif num_wires == 6:
            if "jaune" not in wires and self.last_digit_is_odd():
                return index == 2  # Couper le troisième câble
            elif wires.count("jaune") == 1 and wires.count("blanc") > 1:
                return index == 3  # Couper le quatrième câble
            elif "rouge" not in wires:
                return index == len(wires) - 1  # Couper le dernier câble
            else:
                return index == 3  # Couper le quatrième câble

        return False

    def check_disarm_button(self):
        if self.button_color == "bleu" and self.button_label == "Abort":
            return 'hold'
        elif self.button_label == "Detonate" and self.batteries > 1:
            return 'press'
        elif self.button_color == "blanc" and "CAR" in self.lit_indicators:
            return 'hold'
        elif self.batteries > 2 and "FRK" in self.lit_indicators:
            return 'press'
        elif self.button_color == "jaune":
            return 'hold'
        elif self.button_color == "rouge" and self.button_label == "Hold":
            return 'press'
        else:
            return 'hold'
