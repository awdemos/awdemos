import pandas
from faker import Faker
import random
import time

fake = Faker()

types = ['home', 'work', 'school', 'cell', 'not sure']

def generate_profile(fake, types):
    profile = fake.profile(fields=['job', 'company', 'website', 'name', 'address', 'mail', 'phone_number'])
    return {
        'Given Name': fake.first_name(),
        'Family Name': fake.last_name(),
        'Organization 1 - Name': profile['company'],
        'Organization 1 - Title': profile['job'],
        'Name': profile['name'],
        'Address 1 - Formatted': profile['address'],
        'Occupation': profile['job'],
        'E-mail 1 - Type': random.choice(types),
        'E-mail 1 - Value': profile['mail'],
        'Phone 1 - Type': random.choice(types),
        'Phone 1 - Value': phn(),
    }

def phn():
    while True:
        part1 = str(random.randint(200,999))
        part2 = str(random.randint(200,888))  # avoid '000' and '9xx'
        part3 = str(random.randint(1000,9999))  # ensure 4 digits
        if '9' not in part2 and part2 != '000' and len(set(part3)) > 1:
            return '{}-{}-{}'.format(part1, part2, part3)

rows = []

for _ in range(2000):  # generate 2000 profiles
    rows.append(generate_profile(fake, types))

output_file = '~/Documents/test_data_{}.csv'.format(time.time())

all = pandas.DataFrame(rows)
all.to_csv(output_file)