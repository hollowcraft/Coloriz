import random

class BombGameLogic:
    def __init__(self):
        self.wires = []
        self.serial_number = self.generate_serial_number()
        self.generate_wires()

    def generate_serial_number(self):
        return ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', k=6))

    def generate_wires(self):
        num_wires = random.randint(3, 6)
        colors = ["rouge", "bleu", "jaune", "noir", "blanc"]
        self.wires = [random.choice(colors) for _ in range(num_wires)]

    def check_disarm(self, index):
        num_wires = len(self.wires)
        last_digit_is_odd = int(self.serial_number[-1]) % 2 == 1

        if num_wires == 3:
            if "rouge" not in self.wires:
                return index == 1  # Couper le deuxième câble
            elif self.wires[-1] == "blanc":
                return index == len(self.wires) - 1  # Couper le dernier câble
            elif self.wires.count("bleu") > 1:
                last_blue = len(self.wires) - 1 - self.wires[::-1].index("bleu")
                return index == last_blue  # Couper le dernier câble bleu
            else:
                return index == len(self.wires) - 1  # Couper le dernier câble

        elif num_wires == 4:
            if self.wires.count("rouge") > 1 and last_digit_is_odd:
                last_red = len(self.wires) - 1 - self.wires[::-1].index("rouge")
                return index == last_red  # Couper le dernier câble rouge
            elif self.wires[-1] == "jaune" and "rouge" not in self.wires:
                return index == 0  # Couper le premier câble
            elif self.wires.count("bleu") == 1:
                return index == 0  # Couper le premier câble
            elif self.wires.count("jaune") > 1:
                return index == len(self.wires) - 1  # Couper le dernier câble
            else:
                return index == 1  # Couper le deuxième câble

        elif num_wires == 5:
            if self.wires[-1] == "noir" and last_digit_is_odd:
                return index == 3  # Couper le quatrième câble
            elif self.wires.count("rouge") == 1 and self.wires.count("jaune") > 1:
                return index == 0  # Couper le premier câble
            elif "noir" not in self.wires:
                return index == 1  # Couper le deuxième câble
            else:
                return index == 0  # Couper le premier câble

        elif num_wires == 6:
            if "jaune" not in self.wires and last_digit_is_odd:
                return index == 2  # Couper le troisième câble
            elif self.wires.count("jaune") == 1 and self.wires.count("blanc") > 1:
                return index == 3  # Couper le quatrième câble
            elif "rouge" not in self.wires:
                return index == len(self.wires) - 1  # Couper le dernier câble
            else:
                return index == 3  # Couper le quatrième câble

        return False
