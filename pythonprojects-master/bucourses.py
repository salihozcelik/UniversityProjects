import pandas as pd
import sys as sys


class Year:                                     # Takes department, distinctSemester, undergradCourses array and year,
    departments = []                                # semester integers.
    year = None
    semester = None
    distinctSemester = []
    undergradCourses = []
    gradCourses = []

    def __init__(self, _year, _departments, depts_data, _semester):       # Initializing Year object
        self.year = _year
        self.departments = _departments
        self.semester = _semester
        self.deptsData = depts_data


class Department:                               # Takes underGrad, name, grad, courses, distinctTeach
    underGrad = None
    name = None
    grad = None
    courses = None
    distinctTeach = {}

    def __init__(self, name):                   # Initializing Department object
        self.name = name
        self.underGrad = set()
        self.grad = set()
        self.courses = []


class Course:                                  # Takes code, name, instr
    code = None
    name = None
    instr = None

    def __lt__(self, other):                    # operator overloading - less than according to code
        return self.code < other.code

    def __init__(self, code, name, instr):         # Initializing Course object
        code = code[0: code.index('.')]
        self.code = code
        self.name = name
        self.instr = instr


allDepartments = ["MANAGEMENT",                 # List of all the Departments
"ASIAN STUDIES",
'ASIAN STUDIES WITH THESIS',
'ATATURK INSTITUTE FOR MODERN TURKISH HISTORY',
'AUTOMOTIVE ENGINEERING',
'MOLECULAR BIOLOGY & GENETICS',
'BUSINESS INFORMATION SYSTEMS',
'BIOMEDICAL ENGINEERING',
'CRITICAL AND CULTURAL STUDIES',
'CIVIL ENGINEERING',
'CONSTRUCTION ENGINEERING AND MANAGEMENT',
'COMPUTER EDUCATION & EDUCATIONAL TECHNOLOGY',
'EDUCATIONAL TECHNOLOGY',
'CHEMICAL ENGINEERING',
'CHEMISTRY',
'COMPUTER ENGINEERING',
'COGNITIVE SCIENCE',
'COMPUTATIONAL SCIENCE & ENGINEERING',
'ECONOMICS',
'EDUCATIONAL SCIENCES',
'ELECTRICAL & ELECTRONICS ENGINEERING',
'ECONOMICS AND FINANCE',
'ENVIRONMENTAL SCIENCES',
'ENVIRONMENTAL TECHNOLOGY',
'EARTHQUAKE ENGINEERING',
'ENGINEERING AND TECHNOLOGY MANAGEMENT',
'FINANCIAL ENGINEERING',
'FOREIGN LANGUAGE EDUCATION',
'GEODESY',
'GEOPHYSICS',
'GUIDANCE & PSYCHOLOGICAL COUNSELING',
'HISTORY',
'HUMANITIES COURSES COORDINATOR',
'INDUSTRIAL ENGINEERING',
'INTERNATIONAL COMPETITION AND TRADE',
'INTERNATIONAL TRADE MANAGEMENT',
'CONFERENCE INTERPRETING',
'INTERNATIONAL TRADE',
'LINGUISTICS',
'WESTERN LANGUAGES & LITERATURES',
'LEARNING SCIENCES',
'MATHEMATICS',
'MECHANICAL ENGINEERING',
'MECHATRONICS ENGINEERING',
'INTERNATIONAL RELATIONS:TURKEY;EUROPE AND THE MIDDLE EAST',
'INTERNATIONAL RELATIONS:TURKEY;EUROPE AND THE MIDDLE EAST WITH THESIS',
'MANAGEMENT INFORMATION SYSTEMS',
'FINE ARTS',
'PHYSICAL EDUCATION',
'PHILOSOPHY',
'PHYSICS',
'POLITICAL SCIENCE&INTERNATIONAL RELATIONS',
'PRIMARY EDUCATION',
'PSYCHOLOGY',
'MATHEMATICS AND SCIENCE EDUCATION',
'SECONDARY SCHOOL SCIENCE AND MATHEMATICS EDUCATION',
'SYSTEMS & CONTROL ENGINEERING',
'SOCIOLOGY',
'SOCIAL POLICY WITH THESIS',
'SOFTWARE ENGINEERING',
'SOFTWARE ENGINEERING WITH THESIS',
'TURKISH COURSES COORDINATOR',
'TURKISH LANGUAGE & LITERATURE',
'TRANSLATION AND INTERPRETING STUDIES',
'SUSTAINABLE TOURISM MANAGEMENT',
'TOURISM ADMINISTRATION',
'TRANSLATION',
'EXECUTIVE MBA',
'SCHOOL OF FOREIGN LANGUAGES']
allDepartmentsCodes = ["AD",                 # List of all the Department's Code
"ASIA",
'ASIA',
'ATA',
'AUTO',
'BIO',
'BIS',
'BM',
'CCS',
'CE',
'CEM',
'CET',
'CET',
'CHE',
'CHEM',
'CMPE',
'COGS',
'CSE',
'EC',
'ED',
'EE',
'EF',
'ENV',
'ENVT',
'EQE',
'ETM',
'FE',
'FLED',
'GED',
'GPH',
'GUID',
'HIST',
'HUM',
'IE',
'INCT',
'INT',
'INTT',
'INTT',
'LING',
'LL',
'LS',
'MATH',
'ME',
'MECA',
'MIR',
'MIR',
'MIS',
'PA',
'PE',
'PHIL',
'PHYS',
'POLS',
'PRED',
'PSY',
'SCED',
'SCED',
'SCO',
'SOC',
'SPL',
'SWE',
'SWE',
'TK',
'TKL',
'TR',
'TRM',
'TRM',
'WTR',
'XMBA',
'YADYOK']


def generate_url(_year, _semester, short_name, dept_name):        # This function generates url by formatting
    dept_name = list(dept_name)                                     # registration site
    for a in range(0, len(dept_name)):
        if dept_name[a] == ' ':
            dept_name[a] = '+'
        if dept_name[a] == '&':
            dept_name[a] = '%'
            dept_name.insert(a+1, '26')
        if dept_name[a] == ':':
            dept_name[a] = '%'
            dept_name.insert(a+1, '3a')
        if dept_name[a] == ';':
            dept_name[a] = '%'
            dept_name.insert(a+1, '2c')
    dept_name = ''.join(dept_name)
    return 'https://registration.boun.edu.tr/scripts/sch.asp?donem={}/' \
           '{}-{}&kisaadi={}&bolum={}'.format(_year, _year+1, _semester, short_name, dept_name)


startDate = int(sys.argv[1][0:4])               # Converting sys args to semester and year integers
endDate = int(sys.argv[2][0:4])
startSemester = 0
endSemester = 0
if sys.argv[1][5:7] == 'Su':
    startSemester = 3
    startDate -= 1
if sys.argv[1][5:7] == 'Sp':
    startSemester = 2
    startDate -= 1
if sys.argv[1][5] == 'F':
    startSemester = 1
if sys.argv[2][5:7] == 'Su':
    endSemester = 3
    endDate -= 1
if sys.argv[2][5:7] == 'Sp':
    endSemester = 2
    endDate -= 1
if sys.argv[2][5] == 'F':
    endSemester = 1


def get_year(_i):             # Generates semester string for CSV head
    _year = startDate + int(_i / 3)
    _semester = (startSemester + _i) % 3
    if _semester == 1:
        return str(_year) + "-" + "Fall"
    if _semester == 2:
        return str(_year+1) + "-" + "Spring"
    else:
        return str(_year+1) + "-" + "Summer"


deptsData = []
years = []
totalDeptData = []
allCourses = []
for i in range(0, len(allDepartments)):            # Setting the environment for size of allDepartments
    allCourses.append(dict())
    deptsData.append([set(), set(), set()])
    totalDeptData.append([0, 0])
for year in range(startDate, endDate+1):            # Works for every year
    semesterStart = 1
    semesterEnd = 3
    if year == startDate:
        semesterStart = startSemester               # Defining the semester for the first and the last years
    if year == endDate:
        semesterEnd = endSemester

    for semester in range(semesterStart, semesterEnd+1):   # Works for every semester
        departments = []
        for j in range(0, len(allDepartments)):            # Works for every department
            url = generate_url(year, semester, allDepartmentsCodes[j], allDepartments[j])
            try:
                tables = pd.read_html(url)                  # Returns list of all tables on page
            except:
                departments.append(Department(allDepartments[j]))  # Handles the empty page
                continue

            courses = tables[3][0]                          # Takes courses according to url'tables
            instructors = tables[3][5]                      # Takes instructors according to url'tables
            courseNames = tables[3][2]                     # Takes courseNames according to url'tables
            del courseNames[0]                              # Deletes the unnecessary things
            del courses[0]
            del instructors[0]
            courseNames = courseNames.values
            department = Department(allDepartments[j])      # Converts the series to array
            courses = courses.values
            instructors = instructors.values
            tempCode = {}                                  # Dictionary holds the dept codes and names
            for i in range(0, len(courses)):               # Works for every course.Indexes course name.
                if type(courses[i]) is float:                   # (CMPE230.2 and CMPE230.1 are same now.)
                    continue
                course = Course(courses[i], courseNames[i], instructors[i])
                tempCode.update({courses[i][0: courses[i].index('.')]: courseNames[i]})  # Prevents the multiple
                department.courses.append(course)                                         # sections in list
            allCourses[j] = dict(allCourses[j])
            allCourses[j] = {**allCourses[j], **tempCode}                   # Sets all courses
            allCourses[j] = list(sorted(allCourses[j].items()))
            instructors = list(filter(lambda x: x != 'STAFF STAFF', instructors))   # Doesn't care instructors not known
            department.distinctTeach = set(instructors)
            for i in range(0, len(department.courses)):     # Determine whether the course graduate or undergraduate
                index = 0
                for s in department.courses[i].code:
                    if index > 4 and not s.isdigit():       # Undergrad courses are 1XX, 2XX, 3XX, 4XX
                        department.underGrad.add(department.courses[i].code)
                        break
                    if s.isdigit():
                        s = int(s)
                        if s > 4:                           # Grad courses are 5XX, 6XX
                            department.grad.add(department.courses[i].code)
                            break
                        else:                               # Undergrad courses are 1XX, 2XX, 3XX, 4XX
                            department.underGrad.add(department.courses[i].code)
                            break
                    index += 1
            departments.append(department)
            deptsData[j][0] = deptsData[j][0].union(department.grad)        # Setting information about
            deptsData[j][1] = deptsData[j][1].union(department.underGrad)      # course on to the sets.
            deptsData[j][2] = deptsData[j][2].union(department.distinctTeach)
            totalDeptData[j][0] += len(department.grad)
            totalDeptData[j][1] += len(department.underGrad)

        years.append(Year(year, departments, deptsData, semester))    # Creating new object according to the information
                                    # Writing the Information
csvHead = "Dept./Prog. (name),Course Code,Course Name,"                     # Head of the Csv
csvDeptHeads = []                                                           # Head of Departments rows
csvBodies = []                                                              # Rows of Departments
nOfInstructors = []                                                         # Total offerings
nOfSemesters = []                                                           # Total offerings
for i in range(0, len(allDepartments)):                                     # Initializes the arrays
    nOfInstructors.append([])
    nOfSemesters.append([])
    csvDeptHeads.append("")
    csvBodies.append([])
    for j in range(0, len(allCourses[i])):
        nOfInstructors[i].append(set())
        nOfSemesters[i].append(0)
        csvBodies[i].append("")
for i in range(0, len(years)):
    csvHead += get_year(i) + ","                                             # Adds the years to CSV head
    for j in range(0, len(allDepartments)):
        if csvDeptHeads[j] == "":                                           # Initializes the departments' head rows
            csvDeptHeads[j] += allDepartmentsCodes[j] + "(" + allDepartments[j] + "),"
            csvDeptHeads[j] += "U" + str(len(years[i].deptsData[j][1])) + " G" \
                               + str(len(years[i].deptsData[j][0])) + ", ,"
        csvDeptHeads[j] += "U" + str(len(years[i].departments[j].underGrad)) + " G" \
                           + str(len(years[i].departments[j].grad))
        csvDeptHeads[j] += " I" + str(len(years[i].departments[j].distinctTeach)) \
                           + ","  # Updates the dept head info as years change
        for k in range(0, len(allCourses[j])):
            if csvBodies[j][k] == "":
                csvBodies[j][k] = " ," + allCourses[j][k][0] + "," + \
                                  allCourses[j][k][1] + ","  # Initializes the dept. bodies
            exist = 0  # Checks if the course exists in this year
            for course in years[i].departments[j].courses:
                if course.code == allCourses[j][k][0]:
                    exist = 1
                    break
            if exist == 1:                                # Adds the 'X' or ' '
                nOfSemesters[j][k] += 1
                csvBodies[j][k] += "X,"
                nOfInstructors[j][k].add(course.instr)
            else:
                csvBodies[j][k] += " ,"
            if i == len(years) - 1:
                csvBodies[j][k] += str(nOfSemesters[j][k]) + "/" + str(len(nOfInstructors[j][k]))

        if i == len(years)-1:
            csvDeptHeads[j] += "U" + str(totalDeptData[j][1]) + " G" + str(totalDeptData[j][0])
            csvDeptHeads[j] += " I" + str(len(years[i].deptsData[j][2]))
print(csvHead + "Total Offerings")
for i in range(0, len(csvBodies)):
    print(str(csvDeptHeads[i]))
    for j in range(0, len(csvBodies[i])):
        print(str(csvBodies[i][j]))
