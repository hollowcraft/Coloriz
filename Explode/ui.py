import tkinter as tk
from tkinter import messagebox
from game import BombGameLogic

class BombGame:
    def __init__(self, root):
        self.root = root
        self.root.title("Keep Talking and Nobody Explodes - Version Simplifiée")
        self.logic = BombGameLogic()
        self.time_left = 5 * 60  # 5 minutes en secondes

        # Interface utilisateur
        self.timer_label = tk.Label(root, text="Temps restant : 05:00", font=("Helvetica", 16))
        self.timer_label.pack(pady=20)

        self.wires_label = tk.Label(root, text=self.display_wires(), font=("Helvetica", 14))
        self.wires_label.pack(pady=20)

        self.serial_label = tk.Label(root, text=f"Numéro de série : {self.logic.serial_number}", font=("Helvetica", 14))
        self.serial_label.pack(pady=10)

        self.choice_label = tk.Label(root, text="Entrez le numéro du câble à couper :", font=("Helvetica", 14))
        self.choice_label.pack()

        self.choice_entry = tk.Entry(root, font=("Helvetica", 14))
        self.choice_entry.pack(pady=10)

        self.submit_button = tk.Button(root, text="Couper le câble", font=("Helvetica", 14), command=self.cut_wire)
        self.submit_button.pack(pady=20)

        self.update_timer()

    def display_wires(self):
        display = "Câbles :\n"
        for i, color in enumerate(self.logic.wires):
            display += f"{i + 1}: {color}\n"
        return display

    def update_timer(self):
        minutes, seconds = divmod(self.time_left, 60)
        self.timer_label.config(text=f"Temps restant : {minutes:02d}:{seconds:02d}")
        if self.time_left > 0:
            self.time_left -= 1
            self.root.after(1000, self.update_timer)
        else:
            self.game_over(False)

    def cut_wire(self):
        try:
            choice = int(self.choice_entry.get()) - 1
            if choice < 0 or choice >= len(self.logic.wires):
                raise ValueError
        except ValueError:
            messagebox.showerror("Erreur", "Veuillez entrer un numéro de câble valide.")
            return

        if self.logic.check_disarm(choice):
            self.game_over(True)
        else:
            self.game_over(False)

    def game_over(self, success):
        if success:
            messagebox.showinfo("Félicitations !", "Vous avez désamorcé la bombe !")
        else:
            messagebox.showerror("BOOM !", "Vous avez coupé le mauvais câble. La bombe a explosé.")
        self.root.destroy()
