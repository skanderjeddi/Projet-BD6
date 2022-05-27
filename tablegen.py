import csv
import random
import math
import datetime

COUNTRIES_IN_TABLE = 50
PORTS_IN_TABLE = 100
NAVIRES_IN_TABLE = 250

countries_and_continents = []
diplomatic_relationships = [ 'Alliés', 'Alliés Commerciaux', 'Neutres', 'En Guerre' ]
boats_types = [ 'Yacht', 'Flute', 'Galion', 'Gabare', 'Clipper' ]

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

cac_file = open('countries.txt', 'r')
lines = cac_file.readlines()
cac_file.close()
for line in lines:
    line_split = line.split(',')
    countries_and_continents.append((line_split[0], line_split[1].strip()))

nations = open('nation.csv', 'w', newline = '')
nation_csv_writer = csv.writer(nations, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
nations_in_table = random.choices(countries_and_continents, k = COUNTRIES_IN_TABLE)
for i in range(0, COUNTRIES_IN_TABLE):
    nation_csv_writer.writerow([str(i + 1), nations_in_table[i][1]])

relations = open('diplomatie.csv', 'w', newline = '')
relation_csv_writer = csv.writer(relations, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
relations_in_table = [['(None)' for _ in range(COUNTRIES_IN_TABLE)] for _ in range(COUNTRIES_IN_TABLE)]
for i in range(0, COUNTRIES_IN_TABLE):
    for j in range(i + 1, COUNTRIES_IN_TABLE):
        relation = random.choice(diplomatic_relationships)
        relation_csv_writer.writerow([str(i + 1), str(j + 1), relation])
        relations_in_table[i][j] = relation
        relations_in_table[j][i] = relation

ports_positions = []
ports_categories = []
ports_nationalities = []
ports = open('port.csv', 'w', newline = '')
port_csv_writer = csv.writer(ports, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
for i in range(0, PORTS_IN_TABLE):
    longitude, latitude = random_position()
    while((longitude, latitude) in ports_positions):
        longitude, latitude = random_position()
    port_position = nations_in_table[random.randint(0, COUNTRIES_IN_TABLE - 1)]
    port_nationality = port_position[1]
    port_continent = port_position[0]
    port_continent = port_continent.replace("Oceania", "Océanie").replace("South America", "Amérique du Sud").replace("North America", "Amérique du Nord").replace("Africa", "Afrique").replace("Asia", "Asie").replace("Antarctica", "Antarctique")
    port_size = random.randint(1, 5)
    ports_categories.append(port_size)
    ports_positions.append((longitude, latitude))
    ports_nationalities.append(port_nationality)
    port_csv_writer.writerow([str(i + 1), "P" + str(i), str(port_nationality), str(port_continent), str(port_size)])

navires = open('navire.csv', 'w', newline = '')
navire_capacites_marchandise = [ 10, 100, 500, 1000, 2500 ]
navire_capacites_passagers = [ 1, 10, 50, 100, 500 ]
navire_categories = []
navire_nationalities = []
navire_volumes = []
navire_passagers = []
navire_csv_writer = csv.writer(navires, delimiter = ',', quoting = csv.QUOTE_MINIMAL)
for i in range(0, NAVIRES_IN_TABLE):
    navire_type = random.randint(1, 5)
    navire_nationality = nations_in_table[random.randint(0, COUNTRIES_IN_TABLE - 1)][1]
    navire_capacite_marchandise = random.randint(1, navire_capacites_marchandise[navire_type - 1])
    navire_capacite_passagers = random.randint(1, navire_capacites_passagers[navire_type - 1])
    navire_categories.append(navire_type)
    navire_nationalities.append(navire_nationality)
    navire_volumes.append(navire_capacite_marchandise)
    navire_passagers.append(navire_capacite_passagers)
    navire_csv_writer.writerow([str(i + 1), boats_types[navire_type - 1], str(navire_nationality), str(navire_capacite_marchandise), str(navire_capacite_passagers)])