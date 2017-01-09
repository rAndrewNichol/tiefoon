#sim.py
import monty_hall
plays = 100000

# With Switch:
n_goats = 0
n_cars = 0
for i in range(plays):
    if monty_hall.random_play(monty_hall.gen_doors(), True) == "Goat": n_goats += 1
    else: n_cars += 1
print("With Switching:\nGoats: ", n_goats, "\n", "Cars: ", n_cars, "\n")

n_goats = 0
n_cars = 0
# Without Switch:
for i in range(plays):
    if monty_hall.random_play(monty_hall.gen_doors(), False) == "Goat": n_goats +=1
    else: n_cars +=1
print("Without Switching:\nGoats: ", n_goats, "\n", "Cars: ", n_cars)