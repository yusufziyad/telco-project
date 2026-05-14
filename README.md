# Telecom Data Analysis Project

## Overview
This project involves designing a relational database and analyzing telecom dataset using Oracle XE. It fulfills various operational and functional requirements, including data modeling, Docker-based deployment, and writing complex SQL queries for business intelligence.

## Files in this Repository
* **`TABLE_CREATION_SCRIPTS.sql`**: Contains the complete DDL scripts for creating the `TARIFFS`, `CUSTOMERS`, and `MONTHLY_STATS` tables, along with their respective primary keys, foreign keys, and indexes.
* **`SOLUTIONS.sql`**: Contains all the required SQL queries (DML/DQL) to solve the analytical scenarios provided in the assignment. Each query is documented with a detailed, professional explanation of the approach used.
* **`docker-compose.yml`**: A configuration file to easily spin up the Oracle XE database environment, ensuring reproducibility.

## Database Schema Highlights
* Established a structured relational model linking Customers to their Subscribed Tariffs and Monthly Usage Statistics.
* Enforced data integrity using strictly defined data types and Foreign Key constraints.
* Optimized query performance by creating specific indexes on foreign key columns (`TARIFF_ID` and `CUSTOMER_ID`).

## Technologies Used
* Oracle Database XE 21c
* Docker & Docker Compose
* DBeaver (Database Client)
* SQL (DDL, DML, DQL)