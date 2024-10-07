import tkinter as tk
from tkinter import messagebox
from game import BombGameLogic

class BombGame:
    def __init__(self, root):
        self.root = root
        self.root.title("Keep Talking and Nobody Explodes - Version Simplifiée")
        self.logic = BombGameLogic()
        self.time_left = 5 * 60  # 5 minutes en secondes

        self.module_states = {
            1: False,
            2: False
        }

        # Interface utilisateur
        self.timer_label = tk.Label(root, text="Temps restant : 05:00", font=("Helvetica", 16))
        self.timer_label.pack(pady=20)

        self.serial_label = tk.Label(root, text=f"Numéro de série : {self.logic.serial_number}", font=("Helvetica", 14))
        self.serial_label.pack(pady=10)

        self.modules_frame = tk.Frame(root)
        self.modules_frame.pack(pady=20)

        self.module1_frame = tk.Frame(self.modules_frame)
        self.module1_frame.pack(side=tk.LEFT, padx=20)
        self.module2_frame = tk.Frame(self.modules_frame)
        self.module2_frame.pack(side=tk.LEFT, padx=20)

        self.create_module_buttons()

        self.update_timer()

    def get_color_code(self, color_name):
        color_map = {
            "rouge": "#FF0000",
            "bleu": "#0000FF",
            "jaune": "#FFFF00",
            "noir": "#000000",
            "blanc": "#FFFFFF"
        }
        return color_map.get(color_name, "#CCCCCC")  # Retourne gris clair si la couleur n'est pas trouvée

    def create_module_buttons(self):
        if self.logic.module_type == 'wires':
            self.create_cable_buttons()
        #elif self.logic.module_type == 'button':
            #self.create_button_module()

    def create_cable_buttons(self):
        # Module 1
        for i, color in enumerate(self.logic.wires_module1):
            button = tk.Button(self.module1_frame, bg=self.get_color_code(color), width=10, height=2,
                               command=lambda i=i: self.cut_wire(1, i))
            button.grid(row=i, column=0, pady=5, padx=5)

        # Module 2
        for i, color in enumerate(self.logic.wires_module2):
            button = tk.Button(self.module2_frame, bg=self.get_color_code(color), width=10, height=2,
                               command=lambda i=i: self.cut_wire(2, i))
            button.grid(row=i, column=0, pady=5, padx=5)

    def create_button_module(self):
        color = self.logic.button_color
        label = self.logic.button_label
        button = tk.Button(self.module1_frame, text=f"{label}", bg=self.get_color_code(color), width=20, height=2,
                           command=self.handle_button)
        button.pack(padx=20, pady=20)

    def handle_button(self):
        action = self.logic.check_disarm_button()
        if action == 'hold':
            self.show_hold_instructions()
        elif action == 'press':
            self.show_press_instructions()
        self.module_states[1] = True  # Marquer ce module comme désamorcé
        if all(self.module_states.values()):  # Vérifier si tous les modules sont désamorcés
            self.game_over(True)

    def show_hold_instructions(self):
        color = self.logic.button_color
        if color == 'bleu':
            messagebox.showinfo("Instructions", "Relâchez lorsque le chronomètre affiche un 4.")
        elif color == 'blanc':
            messagebox.showinfo("Instructions", "Relâchez lorsque le chronomètre affiche un 1.")
        elif color == 'jaune':
            messagebox.showinfo("Instructions", "Relâchez lorsque le chronomètre affiche un 5.")
        else:
            messagebox.showinfo("Instructions", "Relâchez lorsque le chronomètre affiche un 1.")

    def show_press_instructions(self):
        messagebox.showinfo("Instructions", "Appuyez et relâchez immédiatement le bouton.")

    def update_timer(self):
        minutes, seconds = divmod(self.time_left, 60)
        self.timer_label.config(text=f"Temps restant : {minutes:02d}:{seconds:02d}")
        if self.time_left > 0:
            self.time_left -= 1
            self.root.after(1000, self.update_timer)
        else:
            self.game_over(False)

    def cut_wire(self, module, index):
        if self.logic.check_disarm_wire(module, index):
            self.module_states[module] = True  # Marquer ce module comme désamorcé
            if all(self.module_states.values()):  # Vérifier si tous les modules sont désamorcés
                self.game_over(True)
        else:
            self.game_over(False)

    def game_over(self, success):
        if success:
            messagebox.showinfo("Félicitations !", "Vous avez désamorcé la bombe !")
        else:
            messagebox.showerror("BOOM !", "Vous avez coupé le mauvais câble. La bombe a explosé.")
        self.root.destroy()
