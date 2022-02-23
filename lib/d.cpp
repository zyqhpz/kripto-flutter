#include <iostream>
#include <string>
using namespace std;

class Student
{
    // Question 4(1)
public:
    string name, contacType;
    int id, contactNo, vaccineLevel;
    Student *next;
};

int menu()
{
    // display menu options
    int choice;
    cout << "\n***** APPLICATION MENU *****\n";
    cout << "Choose one from the following: [press 0 to quit]\n";
    cout << "1. To register covid status\n";
    cout << "2. To display record(s)\nYour choice: ";
    cin >> choice;

    return choice;
    // return user’s choice
}

Student *dataStudent()
{
    // Question 4(2)
    char ch;
    // create a new node
    Student *s = new Student();
    // accept user’s data inputs
        cout << "\nStudent Name: ";
        cin >> s->name;
        cout << "Student ID No: ";
        cin >> s->id;
        cout << "Student Contact No: ";
        cin >> s->contactNo;
        cout << endl;
        cout << "What is your contact tracing type? Choose one: [C/CC/CCC]\n1. Covid Positive (C)\n";
        cout << "2. Close Contact (CC)\n";
        cout << "3. Contact to Close Contact (CCC)\n";
        cout << "Contact Type: ";
        cin >> s->contacType;
        cout << "\nWhat is your vaccine level? Choose one: \n";
        cout << "1. One dose completed\n2. Fully vaccinated\n3. Fully vaccinated + booster\n";
        cout << "Vaccine Level: ";
        cin >> s->vaccineLevel;

        s->next = NULL;

    return s;
    // return address of new node to registerRecord()
}

void registerRecord(Student **head)
{
    // Question 4(3)
    // invoke dataStudent() and accept new node’s address
    char ch;
    do
    {
        Student *list = dataStudent(), *p = *head;
        // add new node to linked list
        if (*head == NULL)
            *head = list;
        else
        {
            while (p->next != NULL)
                p = p->next;

            p->next = list;
        }

        cout << "\nDo you want to continue inputting data? [Y/N]: ";
        cin >> ch;
    } while (ch == 'Y');
}

void reg(Student **head)
{
    // Question 4(3)
    // invoke registerRecord() and accept head’s address
    char ch;
    do {
        registerRecord(head);
        cout << "\nDo you want to continue inputting data? [Y/N]: ";
        cin >> ch;
    } while (ch == 'Y');
}

void displayRecord(Student *list)
{
    // Question 4(4)
    int opt, studentid, choice;
    int ctr1 = 0, ctr2 = 0, ctr3 = 0;
    cout << "\nWould you like to display by:\n";
    cout << "1. Individual record\n2. All records\n3. All records with total number of students based on contact tracing type\nYour option: ";
    cin >> opt;

    if (opt == 1)
    {
        cout << "\nEnter student ID: ";
        cin >> studentid;
        bool found = false;
        while ( list != NULL )
        {
            if (list->id == studentid)
            {
                cout << "\nStudent Name: " << list->name << "\n";
                cout << "Student ID: " << list->id << "\n";
                cout << "Student Contact No: " << list->contactNo << "\n";
                cout << "Contact Type: " << list->contacType << "\n";
                cout << "Vaccine Level: " << list->vaccineLevel << "\n";
                found = true;
            }
            list = list->next;
        }

        if (!found)
            cout << "\nNo record found!\n";
    }
    else if (opt == 2)
    {
        while (list != NULL)
        {
            cout << "\nStudent Name: " << list->name << "\n";
            cout << "Student ID: " << list->id << "\n";
            cout << "Student Contact No: " << list->contactNo << "\n";
            cout << "Contact Type: " << list->contacType << "\n";
            cout << "Vaccine Level: " << list->vaccineLevel << "\n";

            list = list->next;
        }
    }
    // Question 5 (optional: bonus mark)
    else if (opt == 3)
    {
        while (list != NULL)
        {
            cout << "\nStudent Name: " << list->name << "\n";
            cout << "Student ID: " << list->id << "\n";
            cout << "Student Contact No: " << list->contactNo << "\n";
            cout << "Contact Type: " << list->contacType << "\n";
            if (list->contacType == "C")
                ctr1++;
            else if (list->contacType == "CC")
                ctr2++;
            else if (list->contacType == "CCC")
                ctr3++;
            cout << "Vaccine Level: " << list->vaccineLevel << "\n";

            list = list->next;
        }
        cout << "\nTotal contract tracing type\n";
        cout << "Covid Positive: " << ctr1;
        cout << "\nClose Contact: " << ctr2;
        cout << "\nContact to Close Contact: " << ctr3 << endl;
    }
    else
    {
        cout << "Invalid choice\n";
        choice = menu();
    }
}

int main()
{

    // declaration of variables
    Student *head = NULL;
    int choice;

    do
    {
        choice = menu();
        switch (choice)
        {
        case 1:
            registerRecord(&head); // call function registerRecord()
            break;
        case 2:
            displayRecord(head); // call function displayRecord ()
            break;
        }
    } while (choice != 0);

    return 0;
}