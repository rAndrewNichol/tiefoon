#monty_hall.py
import random

def gen_doors():
    doors = [0,1,2]
    car = random.randrange(3)
    doors[car] = "Car"
    goats = list(range(3))
    del goats[car]
    for i in goats:
        doors[i] = "Goat"
    return doors

def random_play(doors = ["Goat","Car","Goat"], switch = True):
    goats = []
    [goats.append(i) for i in range(3) if doors[i] == "Goat"]
    pick = random.randrange(3)
    if switch == True:
        if pick in goats:
            return "Car"
        else: return "Goat"
    else:
        if pick in goats:
            return "Goat"
        else: return "Car"
