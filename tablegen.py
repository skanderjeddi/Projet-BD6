import csv
import random
import math
import datetime

NATIONS = 20
PORTS = 50
SHIPS = 75
TRAVELS = 100

countries_and_continents = []
diplomatic_relationships = [ 'Alliés', 'Alliés Commerciaux', 'Neutres', 'En Guerre' ]
ships_general_types = [ 'Yacht', 'Flute', 'Galion', 'Gabare', 'Clipper' ]

def random_date(start_date, end_date):
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    return start_date + datetime.timedelta(days = random_number_of_days)

def random_position():
    pi = math.pi
    cf = 180.0 / pi
    u0 = random.uniform(0.0, 1.0)
    u1 = random.uniform(0.0, 1.0)
    radLat = math.asin(2 * u0 - 1.0)
    radLon = (2 * u1 - 1) * pi
    return (round(radLat * cf, 5), round(radLon * cf, 5))

cac_file = open('./CSV/countries.txt', 'r')
lines = cac_file.readlines()
cac_file.close()
for line in lines:
    line_split = line.split(',')
    countries_and_continents.append((line_split[0].replace('Asia', 'Asie').replace('Africa', 'Afrique').replace('North America', 'Amérique du Nord').replace('South America', 'Amérique du Sud').replace('Oceania', 'Océanie'), line_split[1].strip()))
cac_file.close()

nations_file = open('./CSV/nation.csv', 'w', newline = '')
nation_csv_writer = csv.writer(nations_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
nations_in_table = random.choices(countries_and_continents, k = NATIONS)
for i in range(0, NATIONS):
    nation_csv_writer.writerow([str(i + 1), nations_in_table[i][1]])
nations_file.close()

relations_file = open('./CSV/diplomatie.csv', 'w', newline = '')
relation_csv_writer = csv.writer(relations_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
relations_in_table = dict()
for i in range(0, NATIONS):
    for j in range(i + 1, NATIONS):
        if nations_in_table[i][1] == nations_in_table[j][1]:
            continue
        relation = random.choice(diplomatic_relationships)
        relation_csv_writer.writerow([str(i + 1), str(j + 1), relation])
        relations_in_table[(nations_in_table[i][1], nations_in_table[j][1])] = relation
        relations_in_table[(nations_in_table[j][1], nations_in_table[i][1])] = relation
relations_file.close()

ports_positions = []
ports_sizes = []
ports_nations = []
ports_file = open('./CSV/port.csv', 'w', newline = '')
port_csv_writer = csv.writer(ports_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
for i in range(0, PORTS):
    port_longitude, port_latitude = random_position()
    while((port_longitude, port_latitude) in ports_positions):
        port_longitude, port_latitude = random_position()
    current_port_random = random.randint(0, NATIONS - 1);
    current_port_position = nations_in_table[current_port_random]
    current_port_nation = current_port_position[1]
    current_port_continent = current_port_position[0]
    current_port_size = random.randint(1, 5)
    ports_sizes.append(current_port_size)
    ports_positions.append((port_longitude, port_latitude))
    ports_nations.append(current_port_nation)
    port_csv_writer.writerow([str(i + 1), "P" + str(i + 1), str(current_port_random + 1), str(current_port_continent), str(current_port_size)])
ports_file.close()

ships_file = open('./CSV/navire.csv', 'w', newline = '')
ships_capacities_merchandise = [ 10, 100, 500, 1000, 2500 ]
ships_capacities_people = [ 1, 10, 50, 100, 500 ]
ships_types = []
ships_nations = []
ships_volumes = []
ships_people = []
ships_csv_writer = csv.writer(ships_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
for i in range(0, SHIPS):
    current_ship_type = random.randint(1, 5)
    csr = random.randint(0, NATIONS - 1)
    current_ship_nation = nations_in_table[csr][1]
    current_ship_merch = random.randint(1, ships_capacities_merchandise[current_ship_type - 1])
    current_ship_people = random.randint(1, ships_capacities_people[current_ship_type - 1])
    ships_types.append(current_ship_type)
    ships_nations.append(current_ship_nation)
    ships_volumes.append(current_ship_merch)
    ships_people.append(current_ship_people)
    ships_csv_writer.writerow([str(i + 1), ships_general_types[current_ship_type - 1], str(csr + 1), str(current_ship_merch), str(current_ship_people)])
ships_file.close()

travels_file = open('./CSV/voyage.csv', 'w', newline = '')
travels_csv_writer = csv.writer(travels_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
travels_dates = [[] for _ in range(TRAVELS + 1)]
travels_distances_categories = [ 1, 1000, 2001, 5000 ]
travel_distances = [[0 for _ in range(PORTS + 1)] for _ in range(PORTS + 1)]
travels_types = []
travels_ships = []
travels_duration = 0
for i in range(0, TRAVELS):
    current_port_source = random.randint(0, PORTS - 1)
    current_port_destination = random.randint(0, PORTS - 1)
    current_nation_source = ports_nations[current_port_source]
    current_nation_destination = ports_nations[current_port_destination]
    while current_nation_source == current_nation_destination:
        current_port_source = random.randint(0, PORTS - 1)
        current_port_destination = random.randint(0, PORTS - 1)
        current_nation_source = ports_nations[current_port_source]
        current_nation_destination = ports_nations[current_port_destination]
    current_ship = random.randint(0, SHIPS - 1)
    while(relations_in_table[(current_nation_source, current_nation_destination)] == 'En Guerre'):
        current_port_destination = random.randint(0, PORTS - 1)
        current_nation_destination = ports_nations[current_port_destination]
        while current_nation_source == current_nation_destination:
            current_port_destination = random.randint(0, PORTS - 1)
            current_nation_destination = ports_nations[current_port_destination]
    # while(relations_in_table[(current_nation_source, ships_nations[current_ship])] == 'En Guerre'):
    #    current_ship = random.randint(0, SHIPS - 1)
    current_destination_continent, current_source_continent = '', ''
    for k in countries_and_continents:
        if k[1] == current_nation_destination:
            current_destination_continent = k[0]
        if k[1] == current_nation_source:
            current_source_continent = k[0]
    current_travel_category = random.randint(1, 3)
    start_date = random_date(datetime.date(1971, 1, 1), datetime.date(2022, 5, 24))
    for j in sorted(travels_dates[i - 1]):
        while(j[0] <= start_date <= j[1]):
            start_date = random_date(datetime.date(1971, 1, 1), datetime.date(2022, 5, 24))
    current_travel_distance = random.randint(travels_distances_categories[current_travel_category - 1], travels_distances_categories[current_travel_category])
    if(travel_distances[current_port_source][current_port_destination] == 0):
        travel_distances[current_port_source][current_port_destination] = current_travel_distance
        travel_distances[current_port_destination][current_port_source] = current_travel_distance
    if(0 < travel_distances[current_port_source][current_port_destination] < 1000):
        current_travel_category = 1
        end_date = random_date(start_date + datetime.timedelta(days = 30), start_date + datetime.timedelta(days = 40))
    elif(1000 <= travel_distances[current_port_source][current_port_destination] <= 2000):
        current_travel_category = 2
        end_date = random_date(start_date + datetime.timedelta(days=50), start_date + datetime.timedelta(days = 180))
    else:
        current_travel_category = 3
        while(ships_types[current_ship] != 5):
            current_ship = random.randint(0, SHIPS - 1)
        end_date = random_date(start_date + datetime.timedelta(days=190), start_date + datetime.timedelta(days = 450))
    if (current_travel_category != 1 and current_nation_source[0] != current_nation_destination[0]):
        while(ships_types[current_ship] != 5):
            current_ship = random.randint(0, SHIPS - 1)
    travels_dates[current_ship].append((start_date, end_date))
    travels_types.append(current_travel_category)
    travels_ships.append(current_ship)
    continentvoyage = current_destination_continent if current_source_continent == current_destination_continent else "Intercontinental"
    ct = ''
    if current_travel_category == 1:
        ct = 'Court'
    elif current_travel_category == 2:
        ct = 'Moyen'
    elif current_travel_category == 3:
        ct = 'Long'
    travels_csv_writer.writerow([str(i + 1), start_date, end_date, str(current_ship + 1), str(current_port_source + 1), str(current_port_destination + 1), ct, continentvoyage])
travels_file.close()

perishable_products_type2 = [ ('Oranges', '268'), ('Fraises', '84'), ('Ananas', '546'), ('Avocat', '321') ]
perishable_products_type1 = [ ('Lait', '852'), ("Pommes", '242'), ('Beurre', '51') ]
nonperishable_products = [ ('Sel', '1'), ('Poivre', '3'), ('Sucre', '2'), ('Café', '5'), ('Tabac', '10'), ('Rhum', '950'), ('Chandelles', '100'), ('Bois', '5000') ]
products_combined = perishable_products_type2 + perishable_products_type1 + nonperishable_products
produits_file = open('./CSV/produit.csv', 'w', newline = '')
produit_csv_writer = csv.writer(produits_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
for i in range(0, len(products_combined)):
    perish = False
    if i < len(perishable_products_type2 + perishable_products_type1):
        perish = True
    produit_csv_writer.writerow([str(i + 1), products_combined[i][0], products_combined[i][1], perish])
produits_file.close()