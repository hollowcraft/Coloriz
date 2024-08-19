from bomb import Bomb

def main():
    print("Bienvenue dans Keep Talking and Nobody Explodes (version simplifiée) !")
    
    bomb = Bomb()
    bomb.display_wires()
    print(f"Numéro de série : {bomb.serial_number}")
    
    choice = int(input("Quel câble voulez-vous couper ? (Entrez le numéro) : "))
    
    if bomb.cut_wire(choice):
        print("Vous avez désamorcé la bombe ! Félicitations !")
    else:
        print("BOOM ! Vous avez coupé le mauvais câble...")

if __name__ == "__main__":
    main()
