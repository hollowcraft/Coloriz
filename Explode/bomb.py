import random
from rules import check_disarm

class Bomb:
    def __init__(self):
        self.wires = []
        self.serial_number = self.generate_serial_number()
        self.generate_wires()

    def generate_serial_number(self):
        # Génère un numéro de série aléatoire (ex: "AB12C4")
        return ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', k=6))

    def generate_wires(self):
        num_wires = 3 #random.randint(3, 6)
        colors = ["rouge", "bleu", "jaune", "noir", "blanc"]
        
        for _ in range(num_wires):
            color = random.choice(colors)
            self.wires.append(color)

    def display_wires(self):
        print("Voici les câbles présents :")
        for i, color in enumerate(self.wires):
            print(f"{i + 1}: {color}")

    def cut_wire(self, choice):
        if choice < 1 or choice > len(self.wires):
            print("Choix invalide !")
            return False
        
        # Applique les règles pour déterminer si le bon câble a été coupé
        return check_disarm(self.wires, choice - 1, self.serial_number)
