# 🏛️ Election Dashboard: High-Performance Data Visualization

**Project Description:** A fully featured Election Dashboard built to monitor and analyze real-time results for the Maharashtra State Assembly Election 2019. This application is engineered for performance and data integrity, leveraging a modern Ruby on Rails and MongoDB architecture.

## ✨ Key Architectural Highlights

* **RESTful API Design:** Developed a comprehensive set of CRUD endpoints and data-fetching APIs following REST principles, critical for modularity and scalability.
* **Server-Side Data Processing:** Implemented a robust server-side processing layer using **Ruby on Rails** controllers and MongoDB/Mongoid to handle data-intensive operations (sorting, searching, filtering) for all data tables. This approach prevents client-side performance bottlenecks.
* **MongoDB Aggregation for Reporting:** Utilized advanced **MongoDB Aggregation Pipelines** within the Mongoid ODM to perform complex, real-time calculations (e.g., total voter count, distinct party counts) directly on the database, significantly boosting reporting speed.
* **Containerized Environment:** Production-ready configuration via a **Dockerfile** and Puma, ensuring consistent deployment across environments.

## 🛠️ Technology Stack

| Layer | Technology | Details |
| :--- | :--- | :--- |
| **Backend** | **Ruby on Rails** (v7.1.3) | Core application framework. Implements business logic and API endpoints. |
| **Database** | **MongoDB** with **Mongoid** (v9.0.0) | Non-relational database for flexible data storage, managed via the Mongoid ODM. |
| **Frontend** | **jQuery, AJAX, JavaScript** | Enables dynamic and responsive UI components. Used for asynchronous table data fetching. |
| **Data Tables** | **DataTables.js** | Used for creating powerful, interactive tables with dynamic search and pagination logic. |
| **Testing** | **RSpec, FactoryBot, DatabaseCleaner** | Robust test suite for models and controllers, ensuring code reliability and TDD compliance. |
| **DevOps** | **Docker** & **GitHub Actions** | Used for containerization and Continuous Integration/Continuous Deployment (CI/CD) pipelines. |

## 🚀 Core Functionality

The application provides interactive, paginated, and filterable dashboards for the following data entities:

* **Users Dashboard (`/users`):** Displays user demographic data. Features custom filters for **Name**, **Gender**, and **Constituency ID** with dynamic filter options fetched via a dedicated API endpoint (`users/gender_options`).
* **Candidates Dashboard (`/candidates`):** Presents candidate-specific metrics, including votes obtained and vote share. Calculates **Total Votes Obtained** and **Average Votes Obtained** in real-time based on current filters.
* **Constituencies Dashboard (`/constituencies`):** Summarizes electoral regions. Calculates **Total Voter Count** and **Total Candidate Count** dynamically using MongoDB aggregation on the filtered dataset.
* **Parties Dashboard (`/parties`):** Allows navigation and review of party-specific information and their associated candidates.
