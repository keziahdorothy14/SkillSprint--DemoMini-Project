import java.io.*;
import java.util.*;

// -------------------- LESSON CLASS --------------------
class Lesson implements Serializable {
    private String title, description, notes;

    public Lesson(String title, String description, String notes) {
        this.title = title;
        this.description = description;
        this.notes = notes;
    }

    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getNotes() { return notes; }
}

// -------------------- SKILL CLASS --------------------
class Skill implements Serializable {
    private String name;
    private List<Lesson> lessons;

    public Skill(String name) {
        this.name = name;
        this.lessons = new ArrayList<>();
    }

    public String getName() { return name; }
    public void addLesson(Lesson lesson) { lessons.add(lesson); }
    public List<Lesson> getLessons() { return lessons; }
}

// -------------------- USER CLASS --------------------
class User implements Serializable {
    String name, email;
    private Map<String, Set<Integer>> completedLessons;

    public User(String name, String email) {
        this.name = name;
        this.email = email;
        this.completedLessons = new HashMap<>();
    }

    public void completeLesson(String skillName, int lessonIndex) {
        completedLessons.putIfAbsent(skillName, new HashSet<>());
        completedLessons.get(skillName).add(lessonIndex);
    }

    public boolean isLessonCompleted(String skillName, int lessonIndex) {
        return completedLessons.containsKey(skillName) &&
                completedLessons.get(skillName).contains(lessonIndex);
    }

    public double getProgress(String skillName, int totalLessons) {
        int done = completedLessons.getOrDefault(skillName, new HashSet<>()).size();
        return totalLessons == 0 ? 0 : (double) done / totalLessons;
    }

    public Set<Integer> getCompletedLessons(String skillName) {
        return completedLessons.getOrDefault(skillName, new HashSet<>());
    }
}

// -------------------- MAIN APP --------------------
public class SkillSprintConsole {
    private static Map<String, Skill> skills = new LinkedHashMap<>();
    private static User user;
    private static final String SAVE_FILE = "user_progress_console.dat";
    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        setupSkillsWithNotes();
        login();
        mainMenu();
    }

    // -------------------- LOGIN --------------------
    private static void login() {
        System.out.print("Enter your name: ");
        String name = scanner.nextLine().trim();
        System.out.print("Enter your email: ");
        String email = scanner.nextLine().trim();
        user = loadProgress(name, email);
        System.out.println("\nWelcome, " + user.name + "!\n");
    }

    // -------------------- MAIN MENU --------------------
    private static void mainMenu() {
        while(true) {
            System.out.println("----- Dashboard -----");
            int index = 1;
            List<String> skillNames = new ArrayList<>();
            for(String skillName : skills.keySet()) {
                Skill skill = skills.get(skillName);
                double progress = user.getProgress(skillName, skill.getLessons().size()) * 100;
                System.out.printf("%d. %s (%.0f%% completed)\n", index++, skillName, progress);
                skillNames.add(skillName);
            }
            System.out.println(skillNames.size()+1 + ". View Overall Progress");
            System.out.println(skillNames.size()+2 + ". Exit");

            System.out.print("Choose a skill or option: ");
            int choice = readInt();
            if(choice >=1 && choice <= skillNames.size()) {
                skillMenu(skillNames.get(choice-1));
            } else if(choice == skillNames.size()+1) {
                viewProgress();
            } else if(choice == skillNames.size()+2) {
                saveProgress(user);
                System.out.println("Progress saved. Goodbye!");
                break;
            } else {
                System.out.println("Invalid choice. Try again.");
            }
        }
    }

    // -------------------- SKILL MENU --------------------
    private static void skillMenu(String skillName) {
        while(true) {
            System.out.println("\n--- " + skillName + " ---");
            System.out.println("1. View Lessons");
            System.out.println("2. View Completed Lessons");
            System.out.println("3. Back to Dashboard");
            System.out.print("Choose an option: ");
            int choice = readInt();
            if(choice == 1) {
                openLessons(skillName);
            } else if(choice == 2) {
                viewCompletedLessons(skillName);
            } else if(choice == 3) {
                break;
            } else {
                System.out.println("Invalid choice. Try again.");
            }
        }
    }

    // -------------------- OPEN LESSONS --------------------
    private static void openLessons(String skillName) {
        Skill skill = skills.get(skillName);
        while(true) {
            System.out.println("\n--- " + skillName + " Lessons ---");
            List<Lesson> lessonList = skill.getLessons();
            for(int i=0;i<lessonList.size();i++) {
                Lesson lesson = lessonList.get(i);
                String mark = user.isLessonCompleted(skillName,i) ? "✅" : "";
                System.out.printf("%d. %s %s\n", i+1, lesson.getTitle(), mark);
            }
            System.out.println(lessonList.size()+1 + ". Back to Skill Menu");

            System.out.print("Select a lesson to view: ");
            int choice = readInt();
            if(choice >=1 && choice <= lessonList.size()) {
                openLessonDetail(skillName, choice-1);
            } else if(choice == lessonList.size()+1) {
                break;
            } else {
                System.out.println("Invalid choice. Try again.");
            }
        }
    }

    // -------------------- LESSON DETAIL --------------------
    private static void openLessonDetail(String skillName, int lessonIndex) {
        Skill skill = skills.get(skillName);
        Lesson lesson = skill.getLessons().get(lessonIndex);
        System.out.println("\n--- " + lesson.getTitle() + " ---");
        System.out.println("Description: " + lesson.getDescription());
        System.out.println("Notes: " + lesson.getNotes());

        if(user.isLessonCompleted(skillName, lessonIndex)) {
            System.out.println("You have already completed this lesson ✅");
        } else {
            System.out.print("Mark as complete? (y/n): ");
            String input = scanner.nextLine().trim().toLowerCase();
            if(input.equals("y")) {
                user.completeLesson(skillName, lessonIndex);
                saveProgress(user);
                System.out.println("Lesson marked as complete ✅");
            }
        }
    }

    // -------------------- VIEW COMPLETED LESSONS --------------------
    private static void viewCompletedLessons(String skillName) {
        Skill skill = skills.get(skillName);
        Set<Integer> completed = user.getCompletedLessons(skillName);
        System.out.println("\n--- Completed Lessons for " + skillName + " ---");
        if(completed.isEmpty()) {
            System.out.println("No lessons completed yet.");
        } else {
            for(int index : completed) {
                System.out.println("- " + skill.getLessons().get(index).getTitle());
            }
        }
        System.out.println();
    }

    // -------------------- VIEW PROGRESS --------------------
    private static void viewProgress() {
        System.out.println("\n--- Overall Progress ---");
        for(String skillName : skills.keySet()) {
            Skill skill = skills.get(skillName);
            double progress = user.getProgress(skillName, skill.getLessons().size())*100;
            System.out.printf("%s: %.0f%% completed\n", skillName, progress);
        }
        System.out.println();
    }

    // -------------------- SETUP SKILLS WITH DETAILED NOTES --------------------
    private static void setupSkillsWithNotes() {
        // Flutter
        Skill flutter = new Skill("Flutter Development");
        flutter.addLesson(new Lesson("Intro to Flutter","Widgets, Stateless vs Stateful","Flutter is a UI toolkit by Google. Stateless widgets don't change; Stateful widgets do."));
        flutter.addLesson(new Lesson("Layouts","Row, Column, Flex","Use Row, Column, and Flex to arrange widgets horizontally and vertically."));
        flutter.addLesson(new Lesson("State Management","setState, Provider","Manage UI state using setState for small apps or Provider for scalable state management."));
        flutter.addLesson(new Lesson("Networking","HTTP, JSON","Use http package to fetch data from APIs and decode JSON responses."));
        flutter.addLesson(new Lesson("Animations","Tween, AnimatedContainer","Create smooth transitions with Tween animations and AnimatedContainer widgets."));
        skills.put(flutter.getName(), flutter);

        // Java
        Skill java = new Skill("Java Programming");
        java.addLesson(new Lesson("Java Basics","Classes, Objects, OOP","Understand objects, classes, methods, and basic OOP concepts like inheritance and polymorphism."));
        java.addLesson(new Lesson("Collections","ArrayList, HashMap","Use ArrayList for ordered data and HashMap for key-value pairs."));
        java.addLesson(new Lesson("Exception Handling","try-catch, I/O","Handle runtime errors with try-catch and manage files with I/O streams."));
        java.addLesson(new Lesson("Threads","Runnable, Synchronization","Implement multithreading with Runnable and synchronize shared resources."));
        java.addLesson(new Lesson("Streams & Lambdas","Stream API","Process collections efficiently using streams and lambda expressions."));
        skills.put(java.getName(), java);

        // Python
        Skill python = new Skill("Python Programming");
        python.addLesson(new Lesson("Python Basics","Variables, Loops, Functions","Learn syntax, loops, conditional statements, and defining functions."));
        python.addLesson(new Lesson("Data Structures","Lists, Dictionaries, Tuples","Use Python built-in structures to store and manage data efficiently."));
        python.addLesson(new Lesson("OOP","Classes, Objects, Inheritance","Implement OOP in Python with classes, methods, and inheritance."));
        python.addLesson(new Lesson("File Handling","Open, Read, Write","Read/write files with open(), and manage files using context managers."));
        python.addLesson(new Lesson("Libraries","NumPy, Pandas","Use NumPy for arrays and Pandas for data manipulation."));
        skills.put(python.getName(), python);

        // Web
        Skill web = new Skill("Web Development");
        web.addLesson(new Lesson("HTML Basics","Tags, Elements","HTML forms the structure of a web page using tags and elements."));
        web.addLesson(new Lesson("CSS Styling","Selectors, Flexbox","Style web pages using CSS selectors and layout with Flexbox."));
        web.addLesson(new Lesson("JavaScript","DOM, Events","Make pages dynamic using JavaScript and handle user events."));
        web.addLesson(new Lesson("Responsive Design","Media Queries","Use media queries to make web pages mobile-friendly."));
        web.addLesson(new Lesson("Frameworks","React, Angular","Use modern frameworks to create scalable and dynamic web apps."));
        skills.put(web.getName(), web);

        // SQL
        Skill sql = new Skill("SQL & Databases");
        sql.addLesson(new Lesson("SQL Basics","SELECT, INSERT, UPDATE","Learn basic SQL commands to manage and query relational databases."));
        sql.addLesson(new Lesson("Joins","INNER, LEFT, RIGHT","Combine data from multiple tables using JOIN operations."));
        sql.addLesson(new Lesson("Indexes","Primary, Foreign Keys","Optimize queries with indexes and ensure relationships with primary/foreign keys."));
        sql.addLesson(new Lesson("Transactions","Commit, Rollback","Ensure data consistency using transactions with commit and rollback."));
        sql.addLesson(new Lesson("Advanced SQL","Views, Stored Procedures","Use views and stored procedures for complex operations."));
        skills.put(sql.getName(), sql);

        // Git
        Skill git = new Skill("Git & GitHub");
        git.addLesson(new Lesson("Git Basics","init, add, commit","Initialize repositories, stage changes, and commit."));
        git.addLesson(new Lesson("Branches","create, merge","Work on features in branches and merge them into main."));
        git.addLesson(new Lesson("Remote","push, pull","Sync your local repo with GitHub remote repository."));
        git.addLesson(new Lesson("Conflicts","Resolve conflicts","Handle merge conflicts during collaborative work."));
        git.addLesson(new Lesson("Advanced Git","Rebase, Stash","Use rebase to streamline commits and stash to save changes temporarily."));
        skills.put(git.getName(), git);

        // Android
        Skill android = new Skill("Android Development");
        android.addLesson(new Lesson("Activity Lifecycle","onCreate, onStart","Understand lifecycle methods and their sequence in an Activity."));
        android.addLesson(new Lesson("Layouts","ConstraintLayout, RecyclerView","Design UIs using ConstraintLayout and dynamic lists with RecyclerView."));
        android.addLesson(new Lesson("Intents","Explicit, Implicit","Navigate between activities and apps using intents."));
        android.addLesson(new Lesson("Data Storage","SharedPreferences, SQLite","Store small data in SharedPreferences and structured data in SQLite."));
        android.addLesson(new Lesson("Networking","Retrofit, Volley","Fetch and send data to servers using Retrofit or Volley."));
        skills.put(android.getName(), android);

        // Data Science
        Skill ds = new Skill("Data Science");
        ds.addLesson(new Lesson("Statistics","Mean, Median, Std Dev","Understand basic statistics concepts for data analysis."));
        ds.addLesson(new Lesson("Data Visualization","Matplotlib, Seaborn","Create plots and charts to visualize datasets."));
        ds.addLesson(new Lesson("Data Cleaning","Missing values, Outliers","Prepare clean datasets by handling missing values and outliers."));
        ds.addLesson(new Lesson("Machine Learning","Regression, Classification","Build basic ML models using regression and classification techniques."));
        ds.addLesson(new Lesson("Model Evaluation","Accuracy, Precision","Evaluate model performance with metrics like accuracy and precision."));
        skills.put(ds.getName(), ds);
    }

    // -------------------- SAVE & LOAD --------------------
    private static void saveProgress(User user) {
        try (ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(SAVE_FILE))) {
            out.writeObject(user);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static User loadProgress(String name, String email) {
        File file = new File(SAVE_FILE);
        if(file.exists()) {
            try (ObjectInputStream in = new ObjectInputStream(new FileInputStream(file))) {
                User savedUser = (User) in.readObject();
                if(savedUser != null && savedUser.name.equals(name) && savedUser.email.equals(email)) {
                    return savedUser;
                }
            } catch (IOException | ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
        return new User(name,email);
    }

    // -------------------- UTILITY --------------------
    private static int readInt() {
        while(true) {
            try {
                return Integer.parseInt(scanner.nextLine().trim());
            } catch(NumberFormatException e) {
                System.out.print("Enter a valid number: ");
            }
        }
    }
}
