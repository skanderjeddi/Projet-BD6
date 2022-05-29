import csv
import random
import math
import datetime

NATIONS = 192
PORTS = 1022 + NATIONS
SHIPS = 3124
TRAVELS = 6202

DIPLOMATIC_RELATIONSHIPS = [ 'Alliés', 'Alliés Commerciaux', 'Neutres', 'En Guerre' ]
SHIPS_CATEGORIES = [ 'Yacht', 'Flute', 'Galion', 'Gabare', 'Clipper' ]
SHIPS_CAPACITIES_MERCHANDISE = [ 100, 500, 1000, 2500, 5000 ]
SHIPS_CAPACITIES_PEOPLE = [ 1, 10, 50, 100, 500 ]

def random_date(start_date, end_date):
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    return start_date + datetime.timedelta(days = random_number_of_days)

def random_position():
    cf = 180.0 / math.pi
    angle1 = random.uniform(0.0, 1.0)
    angle2 = random.uniform(0.0, 1.0)
    radLat = math.asin(2 * angle1 - 1.0)
    radLon = (2 * angle2 - 1) * math.pi
    return (round(radLat * cf, 5), round(radLon * cf, 5))

def read_countries():
    cac_file = open('countries.txt', 'r')
    lines = cac_file.readlines()
    cac_file.close()
    countries_and_continents = []
    for line in lines:
        line_split = line.split(',')
        countries_and_continents.append((line_split[0], line_split[1].strip()))
    cac_file.close()
    return countries_and_continents

def write_nations(nations_in_table):
    nations_file = open('./CSV/nation.csv', 'w', newline = '')
    nation_csv_writer = csv.writer(nations_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    for i in range(0, NATIONS):
        nation_csv_writer.writerow([str(i + 1), nations_in_table[i][1]])
    nations_file.close()

def write_products():
    produits = [
        ('Oranges', 10, 245, True),
        ('Pommes', 10, 258, True),
        ('Ananas', 25, 332, True),
        ('Lait', 100, 99, True),
        ('Beurre', 100, 763, True),
        ('Sel', 5, 26, False),
        ('Poivre', 5, 2090, False),
        ('Sucre', 10, 85, False),
        ('Café', 20, 2000, False),
        ('Tabac', 15, 51500, False),
        ('Rhum', 100, 1217, False),
        ('Chandelles', 250, 869, False),
        ('Bois', 500, 7000, False)
    ]
    produits_file = open('./CSV/produit.csv', 'w', newline = '')
    produit_csv_writer = csv.writer(produits_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    i = 0
    for produit in produits:
        produit_csv_writer.writerow([str(i + 1), produit[0], str(produit[1]), str(produit[2]), str(produit[3])])
        i += 1
    produits_file.close()
    return produits

def write_diplomatic_relationships(nations_in_table):
    relations_file = open('./CSV/diplomatie.csv', 'w', newline = '')
    relation_csv_writer = csv.writer(relations_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    relations_in_table = dict()
    for i in range(0, NATIONS):
        for j in range(i + 1, NATIONS):
            if nations_in_table[i][1] == nations_in_table[j][1]:
                continue
            relation = random.choice(DIPLOMATIC_RELATIONSHIPS)
            relation_csv_writer.writerow([str(i + 1), str(j + 1), relation])
            relations_in_table[(str(i + 1), str(j + 1))] = relation
            relations_in_table[(str(j + 1), str(i + 1))] = relation
    relations_file.close()
    return relations_in_table

def write_ports(nations_in_table):
    ports = []
    ports_positions = []
    ports_sizes = []
    ports_nations = []
    ports_file = open('./CSV/port.csv', 'w', newline = '')
    port_csv_writer = csv.writer(ports_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    for i in range(0, NATIONS):
        current_port_position = nations_in_table[i]
        current_port_nation = current_port_position[1]
        current_port_continent = current_port_position[0]
        current_port_size = random.randint(1, 5)
        ports_sizes.append(current_port_size)
        ports_nations.append(current_port_nation)
        ports.append([str(i + 1), "P" + str(i + 1), str(i + 1), str(current_port_continent), str(current_port_size)])
    for i in range(0, PORTS - NATIONS):
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
        ports.append([str(i + NATIONS + 1), "P" + str(i + NATIONS + 1), str(current_port_random + 1), str(current_port_continent), str(current_port_size)])
    for port in ports:
        port_csv_writer.writerow([port[0], port[1], port[2], port[3], port[4]])
    ports_file.close()
    return ports

def write_ships(nations_in_table):
    ships = []
    ships_file = open('./CSV/navire.csv', 'w', newline = '')
    ships_types = []
    ships_nations = []
    ships_volumes = []
    ships_people = []
    ships_csv_writer = csv.writer(ships_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    for i in range(0, SHIPS):
        current_ship_type = random.randint(1, 5)
        csr = random.randint(0, NATIONS - 1)
        current_ship_nation = nations_in_table[csr][1]
        current_ship_merch = random.randint(1, SHIPS_CAPACITIES_MERCHANDISE[current_ship_type - 1])
        current_ship_people = random.randint(1, SHIPS_CAPACITIES_PEOPLE[current_ship_type - 1])
        ships_types.append(current_ship_type)
        ships_nations.append(current_ship_nation)
        ships_volumes.append(current_ship_merch)
        ships_people.append(current_ship_people)
        ships.append([str(i + 1), str(SHIPS_CATEGORIES[current_ship_type - 1]), str(csr + 1), str(current_ship_merch), str(current_ship_people)])
    for ship in ships:
        ships_csv_writer.writerow([ship[0], ship[1], ship[2], ship[3], ship[4]])
    ships_file.close()
    return ships

def write_travels(countries_and_continents, ports, relations_in_table, ships, products):
    travels_file = open('./CSV/voyage.csv', 'w', newline = '')
    steps_file = open('./CSV/etape.csv', 'w', newline = '')
    packing_file = open('./CSV/cargaison.csv', 'w', newline = '')
    travels_csv_writer = csv.writer(travels_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    steps_csv_writer = csv.writer(steps_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    packing_csv_writer = csv.writer(packing_file, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
    travels_dates = [[] for _ in range(TRAVELS + 1)]
    travels_distances_categories = [ 1, 1000, 2001, 5000 ]
    travel_distances = [[0 for _ in range(PORTS + 1)] for _ in range(PORTS + 1)]
    travels_types = []
    travels_ships = []
    steps = []
    packings = []
    total_steps = 0
    steps_counter = 0
    for i in range(0, TRAVELS):
        current_port_source = random.randint(0, PORTS - 1)
        current_port_destination = random.randint(0, PORTS - 1)
        current_nation_source = ports[current_port_source][2]
        current_nation_destination = ports[current_port_destination][2]
        while current_nation_source == current_nation_destination:
            current_port_source = random.randint(0, PORTS - 1)
            current_port_destination = random.randint(0, PORTS - 1)
            current_nation_source = ports[current_port_source][2]
            current_nation_destination = ports[current_port_destination][2]
        current_ship = random.randint(0, SHIPS - 1)
        while(relations_in_table[(current_nation_source, current_nation_destination)] == 'En Guerre'):
            current_port_destination = random.randint(0, PORTS - 1)
            current_nation_destination = ports[current_port_destination][2]
            while current_nation_source == current_nation_destination:
                current_port_destination = random.randint(0, PORTS - 1)
                current_nation_destination = ports[current_port_destination][2]
        # while(relations_in_table[(current_nation_source, ships_nations[current_ship])] == 'En Guerre'):
        #    current_ship = random.randint(0, SHIPS - 1)
        current_destination_continent, current_source_continent = '', ''
        for k in countries_and_continents:
            if k[1] == countries_and_continents[int(current_nation_destination) - 1][1]:
                current_destination_continent = k[0]
            if k[1] == countries_and_continents[int(current_nation_source) - 1][1]:
                current_source_continent = k[0]
        current_travel_category = random.randint(1, 3)
        start_date = random_date(datetime.date(1971, 1, 1), datetime.date(2022, 5, 24))
        for j in sorted(travels_dates[i - 1]):
            while (j[0] <= start_date <= j[1]):
                start_date = random_date(datetime.date(1971, 1, 1), datetime.date(2022, 5, 24))
        current_travel_distance = random.randint(travels_distances_categories[current_travel_category - 1], travels_distances_categories[current_travel_category])
        if (travel_distances[current_port_source][current_port_destination] == 0):
            travel_distances[current_port_source][current_port_destination] = current_travel_distance
            travel_distances[current_port_destination][current_port_source] = current_travel_distance
        if (0 < travel_distances[current_port_source][current_port_destination] < 1000):
            current_travel_category = 1
            end_date = random_date(start_date + datetime.timedelta(days = 30), start_date + datetime.timedelta(days = 40))
        elif (1000 <= travel_distances[current_port_source][current_port_destination] <= 2000):
            current_travel_category = 2
            end_date = random_date(start_date + datetime.timedelta(days=50), start_date + datetime.timedelta(days = 180))
        else:
            current_travel_category = 3
            while(ships[current_ship][1] != 'Clipper'):
                current_ship = random.randint(0, SHIPS - 1)
            end_date = random_date(start_date + datetime.timedelta(days=190), start_date + datetime.timedelta(days = 450))
        if (current_travel_category != 1 and current_nation_source[0] != current_nation_destination[0]):
            while(ships[current_ship][1] != 'Clipper'):
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
            keep_going = True
            random_port_in_random_country = -1
            while keep_going:
                random_choice = random.choice(countries_and_continents)
                while random_choice[0] != current_source_continent or random_choice[1] == current_nation_source or random_choice[1] == current_nation_destination:
                    random_choice = random.choice(countries_and_continents)
                for p in range(0, PORTS):
                    if int(ports[p][2]) == countries_and_continents.index(random_choice) + 1:
                        random_port_in_random_country = p
                        keep_going = False
                        break
                break
            # print(random_port_in_random_country)
            steps.append([str(i + 1), '1', str(random_port_in_random_country + 1), ships[current_ship][4]])
            merch = int(ships[current_ship][3])
            # print(merch)
            used_products = []
            for product in products:
                random_amount = random.randint(1, math.ceil(merch / product[1]))
                # print("F", steps_counter + 1, "merch", merch, "product volume", product[1], "product amount", random_amount)
                if merch - product[1] * random_amount <= 0:
                    continue
                merch -= product[1] * random_amount
                packings.append([str(steps_counter + 1), str(products.index(product) + 1), random_amount])
                used_products.append(product)
            # print(to)
            steps_counter += 1
            # print(used_products)
            c = 1
            keep_going = True
            while keep_going:
                if random.random() > 0.5 and c <= 2:
                    random_choice = random.choice(countries_and_continents)
                    if c == 1:
                        while random_choice[0] != current_source_continent or random_choice[1] == current_nation_source:
                            random_choice = random.choice(countries_and_continents)
                        for p in range(0, PORTS):
                            if int(ports[p][2]) == countries_and_continents.index(random_choice) + 1:
                                pr = random.random()
                                pdelta = None
                                if pr > 0.5: 
                                    pdelta = random.randrange(-int(ships[current_ship][4]), SHIPS_CAPACITIES_PEOPLE[SHIPS_CATEGORIES.index(ships[current_ship][1])] - int(ships[current_ship][4]))
                                steps.append([str(i + 1), str(c + 1), str(p + 1), pdelta])
                                for product in used_products:
                                    # print(steps_counter, product)
                                    random_amount = random.randint(1, max(2, math.ceil(merch / product[1]))) * (-1 if random.random() > 0.5 else 1)
                                    # print("S", steps_counter + 1, "merch", merch, "product volume", product[1], "product amount", random_amount)
                                    if abs(merch - product[1] * random_amount) > int(ships[current_ship][3]):
                                        continue
                                    merch -= product[1] * random_amount
                                    packings.append([str(steps_counter + 1), str(products.index(product) + 1), random_amount])
                                steps_counter += 1
                                c += 1
                                break
                    elif c == 2:
                        while random_choice[0] != current_destination_continent or random_choice[1] == current_nation_destination:
                            random_choice = random.choice(countries_and_continents)
                        for p in range(0, PORTS):
                            if int(ports[p][2]) ==  countries_and_continents.index(random_choice) + 1:
                                pr = random.random()
                                pdelta = None
                                if pr > 0.5: 
                                    pdelta = random.randrange(-int(ships[current_ship][4]), SHIPS_CAPACITIES_PEOPLE[SHIPS_CATEGORIES.index(ships[current_ship][1])] - int(ships[current_ship][4]))
                                steps.append([str(i + 1), str(c + 1), str(p + 1), pdelta])
                                for product in used_products:
                                    # print(steps_counter, product)
                                    random_amount = random.randint(1, max(2, math.ceil(merch / product[1]))) * (-1 if random.random() > 0.5 else 1)
                                    # print("T", steps_counter + 1, "merch", merch, "product volume", product[1], "product amount", random_amount)
                                    if abs(merch - product[1] * random_amount) > int(ships[current_ship][3]):
                                        continue
                                    merch -= product[1] * random_amount
                                    packings.append([str(steps_counter + 1), str(products.index(product) + 1), random_amount])
                                steps_counter += 1
                                c += 1
                                break
                else:
                    keep_going = False
        travels_csv_writer.writerow([str(i + 1), start_date, end_date, str(current_ship + 1), str(current_port_source + 1), str(current_port_destination + 1), ct, continentvoyage])
        i = 0
        for step in steps:
            if step[3] != None:
                steps_csv_writer.writerow([str(total_steps + i + 1), step[0], step[1], step[2], step[3]])
            else:
                steps_csv_writer.writerow([str(total_steps + i + 1), step[0], step[1], step[2], 'null'])
            i += 1
        total_steps += len(steps)
        steps.clear()
    for pack in packings:
        packing_csv_writer.writerow([pack[0], pack[1], pack[2]])
    packing_file.close()
    travels_file.close()
    steps_file.close()

if __name__ == "__main__":
    nations_in_table = read_countries()
    # nations_in_table = random.choices(countries_and_continents, k = NATIONS)
    write_nations(nations_in_table)
    products = write_products()
    relations_in_table = write_diplomatic_relationships(nations_in_table)
    ports = write_ports(nations_in_table)
    ships = write_ships(nations_in_table)
    write_travels(nations_in_table, ports, relations_in_table, ships, products)
