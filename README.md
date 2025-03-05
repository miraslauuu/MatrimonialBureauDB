# Matrimonial Bureau Database (MatrimonialBureauDB)

**Authors:**  
Miraslau Alkhovik (248655) - database code </br>
Praskouya Horbach (248656) - documentation

## Project Overview

The goal of this project is to develop an object-relational database for a matrimonial bureau. The system is designed to manage clients, their preferences, caretaker assignments, date scheduling, and the logging of operations. It supports functionalities for adding, editing, and viewing data in an intuitive way, following the principles of object-oriented data modeling.

## Main Project Assumptions

- **Clients and Caretakers:**
  - Each client is assigned to exactly one caretaker.
  - A caretaker can manage multiple clients (one-to-many relationship).
  - The list of clients for each caretaker is stored in a nested table (`KlientRefTab`) within the `OpiekunowieObjTable`.
  - A client cannot schedule a date with themselves.
  - Clients must be of legal age (validated via birth date).
  - A client who has previously gone on a date with another person can be reassigned only if both parties agree to meet again.

- **Dates:**
  - Each date is assigned to two different clients.
  - A client cannot be scheduled for two dates simultaneously.
  - Dates are stored in the `RandkiObjTable`, with references (`klient1_ref` and `klient2_ref`) pointing to the participating clients.

- **Date Reviews:**
  - Each review is associated with a specific date and the client who provided the review.
  - The date rating must be between 1 and 5.
  - Reviews are stored in the `OpinieRandek` table, which includes detailed comments.

- **Operation Logging:**
  - All system operations are logged in the `LogOperacji` table.
  - Each log entry contains details such as the date and time of the operation, the type of operation (e.g., INSERT, UPDATE, DELETE), and the identifier of the user who performed the operation.
  - Logs can be used for auditing system activities.

- **Matchmaking Process:**
  - Matchmaking is based on client attributes such as age, preferences, interests, values, and partner expectations.
  - The system searches for pairs that have the highest matching score based on established criteria.

- **Matching Criteria:**
  - **Mutual Matching:**  
    Preferences of one person are compared with the characteristics of the other and vice versa, using factors like interests, values, age (both preferred and actual), sexual orientation, and gender.
  - **Exclusion of Mismatched Pairs:**  
    Clients with negative experiences (review rating below 3) or previous unsuccessful dates with a particular person are excluded.
  - **Matching Score:**  
    Each potential pair is rated based on:
    - Feature and preference compatibility (30% weight).
    - Age compatibility (20% weight).
    - Sexual orientation and gender compatibility (50% weight).
  - **Dynamic Filtering:**  
    Initially, the system counts potential candidates, then returns a list sorted in descending order by their matching score.

## Database Schema and Objects

1. **Object Types:**
   - **TypAdres:**  
     Stores address details with attributes such as street, house number, apartment number (optional), postal code, and city.  
     *Function:* `pokaz_adres` returns the full address as text.
   - **TypOsoba:**  
     Represents a person with attributes like `osoba_id`, first name, last name, birth date, and an address (`TypAdres`).  
     *Procedures/Functions:* `pokaz_dane` displays person data; `get_imie_nazwisko` returns the full name.
   - **TypKlient (extends TypOsoba):**  
     Represents a client of the matrimonial bureau. It adds specific attributes such as client status, preferences, preferred features, gender, sexual orientation, and preferred age range.  
     *Function:* `pelne_dane` returns complete client information.
   - **TypRandka:**  
     Represents a date between two clients, with attributes including a unique date ID, meeting date, meeting location, and references to two clients (`klient1_ref` and `klient2_ref`).  
     *Function:* `opis` returns a brief description of the date.
   - **KlientRefTab:**  
     A nested table type used to store references (REF) to `TypKlient` objects, enabling the storage of a client list within caretaker objects.
   - **TypOpiekun:**  
     Represents a caretaker responsible for managing a group of clients. Attributes include a unique caretaker ID, first name, last name, and a nested table (`KlientRefTab`) containing the caretaker’s clients.  
     *Function:* `pokaz_opiekuna` returns a brief description of the caretaker.

2. **Tables:**
   - **KlienciObjTable:**  
     Stores objects of type `TypKlient`. The primary key is `osoba_id`.
   - **RandkiObjTable:**  
     Stores objects of type `TypRandka`. The primary key is `randka_id`.
   - **OpiekunowieObjTable:**  
     Stores objects of type `TypOpiekun`, including a nested table of clients.
   - **PodopieczniStorage:**  
     Stores the nested client entries (references) related to caretakers.
   - **OpinieRandek:**  
     Stores reviews of dates, including review ID, date ID, client ID, rating (1–5), and a comment.
   - **LogOperacji:**  
     Stores logs of all operations performed in the system for auditing purposes. Contains log ID, operation date, operation description, operation type, and user identifier.

3. **Packages and Triggers:**
   - **Package: PakietBiuro**  
     Contains procedures for managing:
     - **Clients:**  
       - `dodaj_klienta` – Add a new client.
       - `wyswietl_klienta` – Display client information.
       - `pobierz_klientow` – Retrieve the list of all clients.
     - **Caretakers:**  
       - `dodaj_opiekuna` – Add a new caretaker.
       - `dodaj_klienta_do_opiekuna` – Assign a client to a caretaker.
       - `pobierz_opiekunow` – Retrieve the list of all caretakers.
       - `pokaz_podopiecznych` – Display the caretaker's clients.
     - **Dates:**  
       - `dodaj_randke` – Add a new date.
       - `pobierz_randki` – Retrieve the list of all dates.
       - `znajdz_pare` – Find a potential match for a client.
     - **Reviews and History:**  
       - `dodaj_opinie` – Add a review for a date.
       - `historia_randek` – Display a client’s date history.
     - **Client Search:**  
       - `wyszukaj_klienta_po_cechach` – Search for a client based on specified features.
   - **Triggers:**
     - `trg_check_randka_self`: Ensures a client is not assigned as both participants in the same date.
     - `trg_check_data_urodzenia`: Validates that a client's birth date is not in the future.
     - `trg_log_operacji`: Logs operations performed on the `KlienciObjTable` into the `LogOperacji` table.
     - `trg_check_double_booking`: Checks that a client does not have overlapping date reservations.

4. **Roles and Privileges:**
   - **Administrator:**  
     - Full system control, including:
       - Access to all tables, object types, and procedures.
       - Ability to view, modify, add, and delete data.
       - Management of the database schema (creating/dropping tables, object types, and users).
       - Execution of all procedures and functions within `PakietBiuro`.
   - **Employee:**  
     - Limited data manipulation rights:
       - Adding and updating client and date data.
       - Viewing information about clients, dates, and caretakers.
       - Executing specific procedures from `PakietBiuro`.
     - Restrictions:
       - No permission to delete data.
       - No ability to modify the database schema (e.g., creating tables, modifying types).

## Features and Capabilities

- **Data Entry:**  
  Add new clients, caretakers, and dates with automatic validation and processing using object-oriented methods and procedures.
- **Complex Relationships:**  
  Support for intricate relationships between objects (client–caretaker, client–date) through nested tables and references.
- **Data Retrieval:**  
  Functions and procedures that enable structured retrieval of data on clients, caretakers, and dates.
- **Operation Logging:**  
  Tracking of all operations within the system for auditing and monitoring purposes.

## Limitations

- **Oracle Database Specificity:**  
  The system uses Oracle-specific object types and mechanisms, which may limit portability to other database systems.
- **Basic Reporting:**  
  The system focuses on essential CRUD operations, logging, and validation without advanced reporting features.
- **Manual Management of References:**  
  Nested references (REF) are not automatically removed, requiring manual management when deleting clients.

---
