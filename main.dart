import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressController.init(); // load saved progress
  runApp(SkillSprintApp());
}

// -------------------- GLOBAL STATE --------------------
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// -------------------- LESSON CONTENT (NO PLACEHOLDERS) --------------------
class LessonContent {
  // Map: skill -> list of lessons. Each lesson is a map with 'title', 'description', 'notes'
  static final Map<String, List<Map<String, String>>> lessons = {
    "Flutter Development": [
      {
        "title": "Introduction to Flutter & Widgets",
        "description":
        "Understand what Flutter is, the widget tree concept, and the difference between StatelessWidget and StatefulWidget.",
        "notes": '''
Step-by-step:
1. Install Flutter SDK and add it to your PATH.
2. Set up an editor (VS Code or Android Studio) and add Flutter/Dart plugins.
3. Create a new project with `flutter create my_app`.
4. Open `lib/main.dart` — `main()` calls `runApp()`, which inflates the widget tree.
5. Use `MaterialApp` as the root for material-styled apps.

Example (small):
- A StatelessWidget does not hold mutable state:
  class Hello extends StatelessWidget {
    Widget build(BuildContext context) => Text('Hello');
  }
- A StatefulWidget holds mutable state in a separate State class.

Mini exercise:
- Create a new Flutter project and replace the default Text with "Hello, Flutter!".
- Toggle between StatelessWidget and StatefulWidget and observe rebuilds.

Best practices:
- Keep build() fast and side-effect free.
- Compose small widgets rather than one large widget.
- Use hot reload to iterate quickly.

Key takeaways:
• Flutter uses a widget tree; everything is a widget.
• Stateless vs Stateful is about where state lives.
• Hot reload dramatically speeds UI iteration.
'''
      },
      {
        "title": "Layouts: Row, Column & Flex",
        "description":
        "Learn to build responsive layouts using Row, Column, Expanded, Flexible and main/cross-axis alignment.",
        "notes": '''
Step-by-step:
1. Start with Column and Row for vertical/horizontal layouts.
2. Use MainAxisAlignment and CrossAxisAlignment to position children.
3. Wrap widgets with Padding/SizedBox/Container for spacing.
4. Use Expanded to let a child fill remaining space.
5. Use Flexible when you want constrained flex behavior.

Example:
- Column(
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [...]),
      Expanded(child: ListView(...)),
    ],
  )

Mini exercise:
- Build a header with an avatar left, title center, and settings icon right using Row.
- Create a layout where one widget takes 2/3 width and another 1/3 using Expanded and flex.

Best practices:
- Avoid deeply nested Rows/Columns — consider LayoutBuilder or CustomMultiChildLayout for complex UIs.
- Use const constructors where possible to improve performance.

Key takeaways:
• Row and Column are fundamental.
• Expanded/Flexible control how children share space.
• Use padding/margins intentionally for consistent spacing.
'''
      },
      {
        "title": "State Management Basics (setState & InheritedWidget)",
        "description":
        "Explore local state handling with setState and an introduction to inherited widgets for lightweight sharing.",
        "notes": '''
Step-by-step:
1. For local UI state, use StatefulWidget + setState(() { ... }).
2. Avoid putting business logic in build(); separate responsibilities.
3. For data shared down the tree, consider InheritedWidget or Provider.
4. Understand when the widget will rebuild and what triggers builds.

Example:
- Counter app: setState(() => _count++);

Mini exercise:
- Implement a counter app with two buttons: Increment and Reset. Observe when build() fires.
- Refactor to lift state up so two sibling widgets can both read/update the counter.

Best practices:
- Keep state as close to where it is used as possible.
- Prefer immutable data models to reduce bugs.
- For medium/large apps, adopt a structured state management solution (Provider, Riverpod, Bloc).

Key takeaways:
• setState is simple but has scope limits.
• Lift state up to share between widgets.
• Choose a state approach that scales with app complexity.
'''
      },
      {
        "title": "Networking & JSON Parsing",
        "description":
        "Fetch remote data using http, parse JSON and map to Dart models to display dynamic content.",
        "notes": '''
Step-by-step:
1. Add `http` to pubspec.yaml and import it.
2. Make a GET request using `http.get(Uri.parse(url))`.
3. Decode JSON with `jsonDecode(response.body)`.
4. Map JSON to typed Dart model classes for safety.
5. Use FutureBuilder to render async data in the UI.

Example:
- final res = await http.get(url);
  final data = jsonDecode(res.body);
  final items = (data as List).map((json) => Item.fromJson(json)).toList();

Mini exercise:
- Fetch posts from https://jsonplaceholder.typicode.com/posts and display titles in a ListView.

Best practices:
- Handle loading and error states gracefully.
- Cache responses where it makes sense.
- Don’t block the UI — always perform network I/O asynchronously.

Key takeaways:
• Use async/await and FutureBuilder for network data.
• Map JSON to models for clarity and type safety.
• Always handle errors and network failures in the UI.
'''
      },
      {
        "title": "Animations & Transitions",
        "description":
        "Create smooth UI using AnimatedContainer, AnimatedOpacity and basic explicit animations with AnimationController.",
        "notes": '''
Step-by-step:
1. Start with implicit animations (AnimatedContainer, AnimatedOpacity) for simple transitions.
2. For custom control, use AnimationController and Tween with an AnimatedBuilder.
3. Dispose AnimationController in State.dispose().
4. Use CurvedAnimation to control timing curves.

Example:
- AnimatedContainer(duration: Duration(milliseconds: 300), width: _expanded ? 200 : 100);

Mini exercise:
- Animate a card's elevation and color on tap using AnimatedContainer.
- Create a fade-in using AnimatedOpacity.

Best practices:
- Prefer implicit animations for simple effects (less code).
- Avoid long, complex animations that delay user interaction.
- Ensure animations are interruptible and accessible.

Key takeaways:
• Implicit animations are easy to use.
• Explicit animations give full control.
• Subtle animations improve user experience when used sparingly.
'''
      },
    ],

    "Java Programming": [
      {
        "title": "Java Basics & OOP Concepts",
        "description":
        "Learn the basics of Java syntax and core OOP principles: classes, objects, inheritance, polymorphism, encapsulation.",
        "notes": '''
Step-by-step:
1. Install JDK and set JAVA_HOME.
2. Understand class structure: public class App { public static void main(String[] args) { } }
3. Learn data types, operators, and control flow (if, for, while).
4. Study OOP pillars: Encapsulation, Inheritance, Polymorphism, Abstraction.

Example:
- class Animal { void speak() {} }
  class Dog extends Animal { void speak() { System.out.println("Woof"); } }

Mini exercise:
- Create a class Person with fields name and age; write a constructor and a method to print details.

Best practices:
- Use private fields and public getters/setters to encapsulate.
- Keep methods short and focused.
- Prefer composition over inheritance where appropriate.

Key takeaways:
• Java is strongly typed and OOP-centric.
• Use classes to model real-world entities.
• Good encapsulation prevents unintended access.
'''
      },
      {
        "title": "Collections & Generics",
        "description":
        "Work with ArrayList, HashMap, HashSet and understand generics to ensure type safety at compile time.",
        "notes": '''
Step-by-step:
1. Use List<E> (ArrayList) for ordered collections.
2. Use Set<E> (HashSet) when uniqueness is required.
3. Use Map<K,V> (HashMap) for key-value storage.
4. Apply generics: List<String> names = new ArrayList<>(); to avoid cast issues.

Example:
- Map<String, Integer> ages = new HashMap<>();
  ages.put("Alice", 30);

Mini exercise:
- Create an ArrayList of integers, add numbers 1..10, and compute their average.

Best practices:
- Use interfaces (List, Map) in variable declarations.
- Be careful with null keys/values in HashMap.
- Prefer immutable collections for thread-safety where needed.

Key takeaways:
• Collections are essential for storing groups of objects.
• Generics improve type safety and readability.
• Know complexity trade-offs (ArrayList vs LinkedList).
'''
      },
      {
        "title": "Exception Handling & I/O",
        "description":
        "Handle errors with try-catch-finally, create custom exceptions, and perform basic file I/O using streams.",
        "notes": '''
Step-by-step:
1. Wrap risky code in try-catch blocks and handle specific exceptions.
2. Use finally or try-with-resources for resource cleanup.
3. Read/write files with BufferedReader/BufferedWriter or Files utility methods.

Example:
- try (BufferedReader br = new BufferedReader(new FileReader("data.txt"))) {
    String line;
    while ((line = br.readLine()) != null) { ... }
  }

Mini exercise:
- Read a CSV file, parse lines, and print each field separated.

Best practices:
- Do not swallow exceptions silently — log or rethrow where appropriate.
- Prefer checked exceptions for recoverable errors.
- Close I/O streams in finally or use try-with-resources.

Key takeaways:
• Proper exception handling avoids crashes.
• Use try-with-resources to manage I/O safely.
• Validate inputs before processing.
'''
      },
      {
        "title": "Threads & Concurrency Basics",
        "description":
        "Understand threads, Runnable, synchronization, and higher-level concurrency utilities from java.util.concurrent.",
        "notes": '''
Step-by-step:
1. Create a Runnable or extend Thread to run concurrent tasks.
2. Use synchronized blocks or locks to protect shared state.
3. Prefer Executors and thread pools instead of creating raw Threads.
4. Use concurrent collections for thread-safe data access.

Example:
- ExecutorService pool = Executors.newFixedThreadPool(4);
  pool.submit(() -> doWork());

Mini exercise:
- Create two threads that increment a shared counter 10,000 times; observe race conditions and fix using synchronization.

Best practices:
- Avoid holding locks for long durations.
- Use higher-level concurrency utilities (ExecutorService, Semaphore).
- Avoid data races by using immutable objects where possible.

Key takeaways:
• Concurrency enables parallelism but introduces complexity.
• Use thread pools for scalable task execution.
• Synchronization is necessary to prevent race conditions.
'''
      },
      {
        "title": "Java Streams & Lambda Expressions",
        "description":
        "Process collections declaratively with streams and lambdas for readable and concise code.",
        "notes": '''
Step-by-step:
1. Convert collection to stream: list.stream().
2. Apply intermediate operations like map(), filter(), sorted().
3. Use terminal operations such as collect(), forEach(), reduce().
4. Use lambda expressions: x -> x * 2.

Example:
- List<String> names = list.stream().filter(s -> s.startsWith("A")).collect(Collectors.toList());

Mini exercise:
- Given a list of integers, use streams to compute the sum of squares of even numbers.

Best practices:
- Keep pipeline operations simple and readable.
- Avoid using stateful operations in parallel streams.
- Understand stream laziness — pipeline runs on a terminal operation.

Key takeaways:
• Streams provide expressive data processing.
• Lambdas reduce boilerplate for inline behavior.
• Streams can be parallelized but be cautious of side effects.
'''
      },
    ],

    "Data Structures & Algorithm": [
      {
        "title": "Arrays & Linked Lists",
        "description":
        "Compare arrays and linked lists — their strengths, weaknesses, and when to use each.",
        "notes": '''
Step-by-step:
1. Arrays provide contiguous memory and O(1) indexing.
2. Linked lists store nodes with pointers; insertion/deletion at a known node is O(1).
3. Implement basic operations: traverse, insert, delete, search.
4. Analyze time and space trade-offs.

Example:
- Array insertion (middle) requires shifting elements; linked list insertion adjusts pointers.

Mini exercise:
- Implement a small singly linked list with append() and print() methods.

Best practices:
- Use arrays when random access is frequent.
- Use linked lists when insertions/deletions dominate and memory overhead is acceptable.

Key takeaways:
• Arrays are fast for reads; linked lists are flexible for inserts.
• Understand when to favor one over the other based on operations and memory.
'''
      },
      {
        "title": "Stacks & Queues",
        "description":
        "Implement and use stacks and queues; understand real-world use-cases like parsing and BFS.",
        "notes": '''
Step-by-step:
1. Stack: push/pop operations (LIFO). Good for function call simulation, undo.
2. Queue: enqueue/dequeue operations (FIFO). Useful for breadth-first search, task scheduling.
3. Implement using arrays or linked lists; consider circular buffer for fixed-size queues.

Example:
- Use stack to evaluate postfix expressions.

Mini exercise:
- Implement an expression evaluator for simple postfix arithmetic using a stack.

Best practices:
- Choose data structure implementation based on performance (array vs list).
- For concurrent producers/consumers, use thread-safe queues.

Key takeaways:
• Stack = LIFO, Queue = FIFO.
• These structures are building blocks for many algorithms.
'''
      },
      {
        "title": "Trees & Binary Search Trees",
        "description":
        "Explore tree traversal algorithms, binary search tree (BST) properties, and balanced trees conceptually.",
        "notes": '''
Step-by-step:
1. Understand node structure: value, left, right.
2. Implement traversals: inorder (left-root-right), preorder, postorder.
3. For BST, left < node < right; search, insert, delete maintain ordering.
4. Learn about balanced trees (AVL, Red-Black) that guarantee O(log n) operations.

Example:
- Inorder traversal of BST results in sorted order of elements.

Mini exercise:
- Build a BST with numbers [7,3,9,2,5] and print inorder traversal.

Best practices:
- For dynamic ordered datasets, prefer balanced BST or tree-based maps.
- Consider library implementations when available.

Key takeaways:
• Trees model hierarchical relationships.
• BST returns log(n) search on average, worst-case can degrade without balancing.
'''
      },
      {
        "title": "Graphs & Traversals",
        "description":
        "Learn graph representations (adjacency list/matrix) and traversals (BFS, DFS) and their applications.",
        "notes": '''
Step-by-step:
1. Choose representation: adjacency list for sparse graphs, adjacency matrix for dense graphs.
2. Implement DFS (stack/recursion) for reachability; BFS for shortest path in unweighted graphs.
3. Use visited arrays to avoid infinite loops in cyclic graphs.
4. Explore topological sort for DAGs and Dijkstra for weighted shortest paths.

Example:
- BFS on a grid finds shortest path in terms of edges.

Mini exercise:
- Implement BFS to find shortest number of steps from source to all nodes in a small graph.

Best practices:
- Use appropriate data structures for efficient traversal.
- For large graphs, consider memory and time complexity before choosing representation.

Key takeaways:
• BFS finds shortest paths in unweighted graphs.
• DFS is useful for connectivity and discovering cycles.
'''
      },
      {
        "title": "Sorting & Searching Algorithms",
        "description":
        "Study common sorts (quick, merge, heap) and binary search along with time/space trade-offs.",
        "notes": '''
Step-by-step:
1. Understand simple sorts: bubble, insertion, selection — good for learning.
2. Learn efficient sorts: merge sort (stable, O(n log n), needs extra space), quicksort (average O(n log n)).
3. Use binary search on sorted arrays for O(log n) lookup.
4. Study heap sort and understand priority queues.

Example:
- Binary search implementation: maintain low/high pointers and compare mid element.

Mini exercise:
- Implement merge sort and verify it sorts an array of random integers.

Best practices:
- Prefer built-in sort (optimized) unless implementing algorithms for education.
- Consider stability and space usage when choosing sort.

Key takeaways:
• Sorting and searching are fundamental.
• Different algorithms offer trade-offs in worst/average-case and memory use.
'''
      },
    ],

    "Python for Beginners": [
      {
        "title": "Python Syntax & Data Types",
        "description":
        "Get comfortable with Python basics: variables, lists, tuples, dicts, sets and string handling.",
        "notes": '''
Step-by-step:
1. Install Python and run `python` REPL.
2. Learn basic types: int, float, str, bool, list, tuple, dict, set.
3. String operations: concatenation, formatting (f-strings), slicing.
4. Lists vs tuples: lists are mutable, tuples are immutable.

Example:
- names = ['Alice', 'Bob']
  greeting = f"Hello, {names[0]}"

Mini exercise:
- Create a list of 5 numbers and compute sum, min, max, and average.

Best practices:
- Use list comprehensions for concise operations.
- Favor tuples for fixed collections and dicts for mappings.

Key takeaways:
• Python's syntax is concise and readable.
• Choose appropriate data type based on mutability and operations needed.
'''
      },
      {
        "title": "Functions, Modules & Virtual Environments",
        "description":
        "Create reusable code with functions, organize projects with modules, and isolate dependencies with venv.",
        "notes": '''
Step-by-step:
1. Define functions with def, add docstrings for clarity.
2. Create modules (separate .py files) and import them.
3. Use `python -m venv env` to create virtual environments.
4. Activate venv and install dependencies into isolated environment.

Example:
- def add(a, b): return a + b

Mini exercise:
- Create a module math_utils.py with a factorial function and import it from main.py.

Best practices:
- Keep functions single-responsibility.
- Use requirements.txt or pyproject.toml to pin dependencies.

Key takeaways:
• Modular code improves reuse and maintainability.
• Virtual environments prevent dependency conflicts.
'''
      },
      {
        "title": "File Handling & Exceptions",
        "description":
        "Read/write files safely and handle exceptions to make your code robust against runtime errors.",
        "notes": '''
Step-by-step:
1. Use `with open(filename) as f:` to auto-close files.
2. Read entire file with read(), or iterate lines with for line in f.
3. Handle exceptions using try/except and use finally if needed.

Example:
- with open('data.txt') as f:
    for line in f: print(line.strip())

Mini exercise:
- Write a program that reads a CSV file and counts rows where a numeric column > threshold.

Best practices:
- Validate file paths and handle missing files gracefully.
- Log exceptions rather than printing in production code.

Key takeaways:
• Use context managers for safe resource handling.
• Catch and handle specific exceptions for clarity.
'''
      },
      {
        "title": "Intro to Libraries: requests & pandas",
        "description":
        "Use requests to fetch web data and pandas for tabular data manipulation and analysis basics.",
        "notes": '''
Step-by-step:
1. Install packages: pip install requests pandas.
2. Use requests.get(url) to fetch content and check response.status_code.
3. Use pandas.read_csv or DataFrame to manage tabular data.
4. Use df.head(), df.describe(), df.isna() to inspect data.

Example:
- import requests
  r = requests.get('https://api.example.com/data')
  data = r.json()

Mini exercise:
- Fetch a CSV from the web and load it into pandas; compute the mean of a numeric column.

Best practices:
- Always check HTTP status codes.
- Handle missing values explicitly before analysis.

Key takeaways:
• requests fetches remote data, pandas simplifies data analysis.
• Inspect and clean data before processing.
'''
      },
      {
        "title": "Basic OOP & Simple Projects",
        "description":
        "Apply object-oriented programming in Python to structure larger programs and build a small project.",
        "notes": '''
Step-by-step:
1. Define classes with __init__ for initialization.
2. Implement methods to encapsulate behavior.
3. Use inheritance to share and extend functionality.
4. Organize project into modules and packages.

Example:
- class Animal:
    def __init__(self, name): self.name = name

Mini exercise:
- Create a simple CLI todo app that stores tasks in a file.

Best practices:
- Keep data and behavior together in classes.
- Write unit tests for core functionality.

Key takeaways:
• OOP in Python improves code organization for larger projects.
• Build small projects to solidify concepts.
'''
      },
    ],

    "Full Stack Development using Java": [
      {
        "title": "Web Basics & Servlets",
        "description":
        "Understand HTTP, request/response model, and create simple Java servlets to handle requests.",
        "notes": '''
Step-by-step:
1. Learn HTTP request/response: methods (GET, POST), headers, status codes.
2. Create a servlet by extending HttpServlet and overriding doGet/doPost.
3. Deploy servlet to a servlet container like Tomcat for local testing.

Example:
- public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
      res.getWriter().write("Hello from servlet");
    }
  }

Mini exercise:
- Create a servlet that accepts a "name" parameter and returns "Hello, {name}".

Best practices:
- Validate request parameters and handle missing/incorrect formats.
- Use proper response status codes (200, 400, 404, 500).

Key takeaways:
• Servlets form the backbone of Java web apps.
• Understand full request lifecycle to build robust endpoints.
'''
      },
      {
        "title": "Spring Boot Fundamentals",
        "description":
        "Learn Spring Boot to create REST APIs quickly with auto-configuration and dependency injection.",
        "notes": '''
Step-by-step:
1. Initialize a Spring Boot project (start.spring.io) with web dependency.
2. Create @RestController classes and define @GetMapping/@PostMapping endpoints.
3. Use @Service and @Repository layers to separate concerns.
4. Run the application with embedded server (Tomcat).

Example:
- @RestController class Hello { @GetMapping("/") String hi() { return "Hi"; } }

Mini exercise:
- Build a small REST API with one GET endpoint returning a JSON list of items.

Best practices:
- Keep controllers thin; delegate logic to services.
- Externalize configuration to application.properties/application.yml.

Key takeaways:
• Spring Boot accelerates API development with sensible defaults.
• Layered architecture improves maintainability.
'''
      },
      {
        "title": "Database Integration (JPA/Hibernate)",
        "description":
        "Integrate with relational databases using JPA, entity mapping, and CRUD repository patterns.",
        "notes": '''
Step-by-step:
1. Add spring-boot-starter-data-jpa and a database driver (e.g., MySQL).
2. Define @Entity classes for tables and use @Id for primary key.
3. Use JpaRepository<T, ID> to obtain CRUD operations.
4. Use @Transactional for operations that must be atomic.

Example:
- @Entity class User { @Id Long id; String name; }

Mini exercise:
- Create an entity Product and implement REST endpoints to create and list products.

Best practices:
- Avoid heavy logic in repositories; use services for business logic.
- Use migrations (Flyway/Liquibase) to manage schema changes.

Key takeaways:
• JPA/Hibernate simplifies ORM mapping.
• Repositories provide standard CRUD easily.
'''
      },
      {
        "title": "Frontend Basics (HTML/CSS/JS) for Java Developers",
        "description":
        "Learn basics of modern frontend to consume APIs: structure pages, style them and add interactivity.",
        "notes": '''
Step-by-step:
1. Create an HTML skeleton with semantic tags (header, nav, main).
2. Style with CSS; learn layouts with Flexbox and Grid.
3. Use JavaScript fetch() to call backend APIs and update DOM.
4. Keep frontend simple for API consumption and focus on usability.

Example:
- fetch('/api/items').then(res => res.json()).then(data => renderList(data));

Mini exercise:
- Build a small page that displays a list of products fetched from the backend.

Best practices:
- Keep UI responsive (mobile-first).
- Separate concerns: HTML for structure, CSS for style, JS for behavior.

Key takeaways:
• Frontend consumes backend APIs — both must be designed together.
• Simple vanilla JS is enough for small apps; use frameworks when complexity grows.
'''
      },
      {
        "title": "Deployment & CI/CD",
        "description":
        "Prepare a Java full-stack app for production and set up simple CI/CD to automate builds and deploys.",
        "notes": '''
Step-by-step:
1. Build JAR/WAR with Maven/Gradle.
2. Create Dockerfile to containerize the application.
3. Use a CI platform (GitHub Actions/Jenkins) to build/test on push.
4. Deploy to a PaaS (Heroku) or Kubernetes cluster for production.

Example:
- Dockerfile: FROM openjdk:11-jre-slim COPY app.jar /app.jar CMD ["java","-jar","/app.jar"]

Mini exercise:
- Create a simple GitHub Actions workflow to build your Maven project on push.

Best practices:
- Automate tests in CI pipeline.
- Use environment variables for configuration, not hard-coded values.

Key takeaways:
• CI/CD automates builds and reduces manual errors.
• Containerization standardizes deployment across environments.
'''
      },
    ],

    "Concepts of Cybersecurity": [
      {
        "title": "Security Fundamentals & Threat Models",
        "description":
        "Learn core security concepts: CIA triad (Confidentiality, Integrity, Availability) and common threat types.",
        "notes": '''
Step-by-step:
1. Understand CIA triad and how it applies to systems.
2. Identify assets, entry points, threats and impacts.
3. Build a simple threat model listing likely attack vectors and mitigations.

Example:
- Asset: user data; Threat: SQL injection; Mitigation: use prepared statements.

Mini exercise:
- Create a threat model for a simple web application and list 3 mitigations.

Best practices:
- Apply least privilege and defense-in-depth principles.
- Regularly update threat models as system evolves.

Key takeaways:
• Threat modeling focuses defense where it matters most.
• CIA triad is a simple lens for assessing security needs.
'''
      },
      {
        "title": "Web Security Basics (OWASP Top 10)",
        "description":
        "Study common web vulnerabilities like XSS, SQLi, CSRF and how to mitigate them.",
        "notes": '''
Step-by-step:
1. Learn the OWASP Top 10 list of common vulnerabilities.
2. For each vulnerability, list prevention techniques (input validation, escaping).
3. Test your app for simple vulnerabilities (e.g., attempt an XSS in a form field).

Example:
- Prevent SQLi by using parameterized queries instead of string concatenation.

Mini exercise:
- Identify inputs in an application and write sanitization/validation rules.

Best practices:
- Sanitize and validate all user inputs.
- Use framework protections (prepared statements, templating escaping).

Key takeaways:
• OWASP Top 10 highlights frequent, impactful web vulnerabilities.
• Prevention is largely about proper input handling and secure defaults.
'''
      },
      {
        "title": "Authentication & Authorization",
        "description":
        "Understand authentication flows (sessions, JWT) and role-based authorization strategies.",
        "notes": '''
Step-by-step:
1. Learn the difference between authentication (who you are) and authorization (what you can do).
2. Study session-based auth vs token-based (JWT).
3. Implement role checks for protected API endpoints.

Example:
- After successful login, issue a short-lived JWT with user id and roles.

Mini exercise:
- Implement a simple login flow in a sample app and protect a route requiring a role.

Best practices:
- Store passwords securely (bcrypt/Argon2).
- Make tokens short-lived and consider refresh tokens.

Key takeaways:
• Secure auth is foundational; poor auth leads to serious breaches.
• Apply least privilege with role-based access control.
'''
      },
      {
        "title": "Network Security Basics",
        "description":
        "Learn about TLS/SSL, secure communication, firewalls, and basic network segmentation.",
        "notes": '''
Step-by-step:
1. Understand how TLS provides confidentiality and integrity for traffic.
2. Use HTTPS by default for all web traffic.
3. Employ firewalls and segmentation to limit attack surfaces.

Example:
- Configure web server to redirect HTTP to HTTPS and use a valid cert.

Mini exercise:
- Inspect HTTPS requests in the browser dev tools and look at cert details.

Best practices:
- Use strong cipher suites and keep TLS libraries up to date.
- Avoid exposing internal admin interfaces to public networks.

Key takeaways:
• HTTPS/TLS is non-negotiable for modern web apps.
• Network controls limit attacker movement.
'''
      },
      {
        "title": "Security Testing & Incident Response",
        "description":
        "Discover penetration testing basics, vulnerability scanning and how to prepare an incident response plan.",
        "notes": '''
Step-by-step:
1. Run periodic vulnerability scans and basic pentests.
2. Prepare an incident response plan with steps: identify, contain, eradicate, recover, lessons learned.
3. Keep logs and monitoring to detect incidents early.

Example:
- Use open-source tools (e.g., Nikto, OWASP ZAP) for quick scans.

Mini exercise:
- Create a simple incident playbook for a stolen credential scenario.

Best practices:
- Practice incident drills and backups.
- Patch critical vulnerabilities promptly.

Key takeaways:
• Detection and response are as important as prevention.
• Playbooks and rehearsals reduce response time during real incidents.
'''
      },
    ],

    "Microsoft Excel": [
      {
        "title": "Excel Interface & Basic Formulas",
        "description":
        "Get to know the Excel UI and core formulas: SUM, AVERAGE, COUNT, and basic cell referencing.",
        "notes": '''
Step-by-step:
1. Explore the Ribbon, cells, rows, columns, and sheets.
2. Enter simple formulas such as =SUM(A1:A10) and =AVERAGE(B1:B10).
3. Learn absolute (A1) vs relative (A1) references for copying formulas.

Example:
- =IF(A1>50, "Pass", "Fail")

Mini exercise:
- Create a table of 10 numbers and calculate total and average using formulas.

Best practices:
- Use named ranges for readability.
- Keep formulas simple and test edge cases (empty cells, text in numeric columns).

Key takeaways:
• Basic formulas are the backbone of spreadsheet analytics.
• Understand cell referencing to correctly copy formulas.
'''
      },
      {
        "title": "Data Cleanup & Text Functions",
        "description":
        "Clean and transform data using TEXT, TRIM, LEFT/RIGHT, MID, and FIND functions.",
        "notes": '''
Step-by-step:
1. Identify dirty data (extra spaces, inconsistent casing).
2. Use TRIM(), UPPER()/LOWER(), and CLEAN() to normalize text.
3. Use LEFT/RIGHT/MID and FIND to extract pieces of text.

Example:
- =TRIM(PROPER(A1))

Mini exercise:
- Given a column of full names "DOE, JOHN", convert to "John Doe".

Best practices:
- Keep a raw data sheet unchanged and make transformations on a copy.
- Document transformations so they are reproducible.

Key takeaways:
• Cleaning data is often the longest part of analysis.
• Excel provides powerful text tools to standardize data quickly.
'''
      },
      {
        "title": "Lookup Functions: VLOOKUP, HLOOKUP & XLOOKUP",
        "description":
        "Perform lookups across tables using VLOOKUP and the more flexible XLOOKUP (if available).",
        "notes": '''
Step-by-step:
1. Use VLOOKUP(lookup_value, table_array, col_index, range_lookup) for vertical lookups.
2. XLOOKUP (newer) allows both-direction lookups and default values when not found.
3. Use INDEX & MATCH combination for robust lookups avoiding VLOOKUP limitations.

Example:
- =XLOOKUP(E2, A:A, B:B, "Not found")

Mini exercise:
- Create two tables and join them using VLOOKUP or XLOOKUP to pull matching rows.

Best practices:
- Prefer exact match (set range_lookup = FALSE) to avoid incorrect results.
- For large datasets, use INDEX+MATCH for performance and flexibility.

Key takeaways:
• Lookup functions join data across tables; choose the right tool for your Excel version.
• XLOOKUP is more powerful and robust than VLOOKUP.
'''
      },
      {
        "title": "PivotTables & Data Summarization",
        "description":
        "Summarize and analyze data quickly using PivotTables and grouping features.",
        "notes": '''
Step-by-step:
1. Select your dataset and insert a PivotTable.
2. Drag fields to Rows, Columns, Values and Filters to create summaries.
3. Use value field settings (sum, count, average) to change aggregation.

Example:
- Create Pivot showing total sales per region and per product category.

Mini exercise:
- Use a sales dataset to create a PivotTable that shows monthly totals and a slicer to filter by region.

Best practices:
- Refresh pivot data when source changes.
- Use calculated fields for custom aggregations.

Key takeaways:
• PivotTables are an essential tool for quick analysis of large tables.
• Slicers improve interactive reporting.
'''
      },
      {
        "title": "Charts & Conditional Formatting",
        "description":
        "Visualize trends with charts (line, bar, pie) and highlight data using conditional formatting rules.",
        "notes": '''
Step-by-step:
1. Select data and insert a chart type appropriate to your story (trend -> line, comparison -> bar).
2. Customize axes, labels, and legend for clarity.
3. Use conditional formatting to highlight top/bottom values or rules-based highlights.

Example:
- Use a line chart to show sales trend across months.

Mini exercise:
- Create a chart and apply conditional formatting to highlight months where sales > target.

Best practices:
- Keep charts uncluttered and label axes clearly.
- Use conditional formatting sparingly to avoid overwhelming users.

Key takeaways:
• Visuals communicate trends faster than tables.
• Conditional formatting surfaces outliers and trends for quick attention.
'''
      },
    ],

    "Interview Questions": [
      {
        "title": "Behavioral Interview Prep",
        "description":
        "Prepare STAR (Situation, Task, Action, Result) answers for common behavioral questions.",
        "notes": '''
Step-by-step:
1. Learn the STAR technique to structure stories: Situation, Task, Action, Result.
2. Prepare 4-6 stories highlighting teamwork, conflict resolution, leadership, and impact.
3. Practice concise delivery within 1-2 minutes per story.

Example:
- Situation: Project deadline missed. Task: Recover timeline. Action: Re-prioritized tasks and added daily standups. Result: Delivered with critical features and received client praise.

Mini exercise:
- Write a STAR response for a time you solved a difficult problem.

Best practices:
- Quantify results where possible (reduced time by 30%).
- Be honest; discuss learning when things went wrong.

Key takeaways:
• STAR structures answers clearly.
• Practice common scenarios to answer confidently during interviews.
'''
      },
      {
        "title": "DSA Common Patterns",
        "description":
        "Study frequently asked data-structure/algorithm patterns: two pointers, sliding window, and hashing.",
        "notes": '''
Step-by-step:
1. Learn common patterns: two pointers (sorted arrays), sliding window (subarray sums), hashing (frequency counts).
2. Identify pattern from problem statement and map it to a template solution.
3. Practice implementing and analyzing time/space complexity.

Example:
- Sliding window to find maximum sum subarray of size k:
  maintain window sum, slide and update max.

Mini exercise:
- Solve: Given array, find longest substring with at most 2 distinct characters (sliding window).

Best practices:
- Sketch examples and small cases before coding.
- Write clear loop invariants and reason about correctness.

Key takeaways:
• Pattern recognition speeds problem solving.
• Master a few patterns and generalize them to new problems.
'''
      },
      {
        "title": "System Design Fundamentals",
        "description":
        "Learn to break down high-level design questions: APIs, databases, scaling and trade-offs.",
        "notes": '''
Step-by-step:
1. Clarify requirements (functional and non-functional).
2. Estimate load (QPS, data size), then choose storage and caching strategies.
3. Design components (API layer, service layer, DB) and data flow; consider scaling and failure modes.

Example:
- Design a simple URL shortener: API endpoints, DB schema, hash function, redirects.

Mini exercise:
- Sketch architecture for a news feed with millions of users: components, data flow, and caching.

Best practices:
- Start high-level then refine; discuss trade-offs (consistency vs availability).
- Use diagrams to communicate architecture clearly.

Key takeaways:
• System design focuses on trade-offs and scalable components.
• Always quantify requirements before picking technologies.
'''
      },
      {
        "title": "Coding Interview Tips & Practice",
        "description":
        "Best practices for live coding interviews: communicate clearly, write tests, and optimize iteratively.",
        "notes": '''
Step-by-step:
1. Clarify the problem and ask about edge cases and constraints.
2. Describe a brute-force approach, then iteratively optimize.
3. Write clean code, test with sample inputs, and discuss complexity.

Example:
- For reversing a linked list: iterate with three pointers (prev, curr, next).

Mini exercise:
- Practice solving 5 problems focusing on arrays, strings, and linked lists, using the above approach.

Best practices:
- Talk through your thought process; don’t code blind.
- Start simple, then optimize and test.

Key takeaways:
• Communication is as important as the final code.
• Iterative approach reduces mistakes and fosters clarity.
'''
      },
      {
        "title": "Mock Interviews & Feedback",
        "description":
        "Simulate interviews, collect feedback, and iterate on weak areas to improve performance.",
        "notes": '''
Step-by-step:
1. Arrange mock interviews with peers or mentors.
2. Record them if possible and review for clarity, correctness, and pacing.
3. Create a feedback log and plan improvements (e.g., data structures, communication).

Example:
- After a mock, note down 3 improvements and make a plan to address them (e.g., 30 mins/day on trees).

Mini exercise:
- Conduct one mock interview and convert feedback into a 2-week practice plan.

Best practices:
- Treat mocks as real interviews to build pressure-handling skills.
- Iterate and track progress over time.

Key takeaways:
• Feedback-driven practice accelerates improvement.
• Mocks reduce anxiety and improve timing.
'''
      },
    ],
  };

  // Safe getters
  static Map<String, String> getLesson(String skill, int number) {
    final list = lessons[skill];
    if (list == null || number < 1 || number > list.length) {
      // Fallback: return a descriptive but non-placeholder entry (shouldn't happen)
      return {
        "title": "General Lesson",
        "description": "This lesson covers important fundamentals for $skill.",
        "notes":
        "• Review course materials.\n• Practice exercises.\n• Reach out for clarifications."
      };
    }
    return list[number - 1];
  }

  static int lessonCount(String skill) {
    return lessons[skill]?.length ?? 0;
  }
}

// -------------------- PROGRESS CONTROLLER (shared_preferences persistence) --------------------
class ProgressController {
  static final Map<String, int> lessonsPerSkill = {
    for (var e in LessonContent.lessons.entries) e.key: e.value.length
  };

  static Map<String, Set<int>> completedLessons = {};
  static String? lastSkill;
  static int? lastLesson;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('completedLessons');
    if (stored != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(stored);
        completedLessons = {};
        decoded.forEach((skill, listDyn) {
          final arr = (listDyn as List<dynamic>).map((e) => e as int).toList();
          completedLessons[skill] = arr.toSet();
        });
      } catch (_) {
        completedLessons = {};
      }
    } else {
      completedLessons = {};
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, List<int>> toSave = {};
    completedLessons.forEach((k, v) => toSave[k] = v.toList());
    await prefs.setString('completedLessons', jsonEncode(toSave));
  }

  static double getProgress(String skill) {
    final total = lessonsPerSkill[skill] ?? 0;
    final done = completedLessons[skill]?.length ?? 0;
    return total == 0 ? 0.0 : done / total;
  }

  static void completeLesson(String skill, int lesson) {
    completedLessons.putIfAbsent(skill, () => <int>{});
    completedLessons[skill]!.add(lesson);
    lastSkill = skill;
    lastLesson = lesson;
    _save();
  }

  static Map<String, dynamic>? getNextLesson() {
    for (var skill in lessonsPerSkill.keys) {
      final total = lessonsPerSkill[skill]!;
      final done = completedLessons[skill] ?? <int>{};
      for (int i = 1; i <= total; i++) {
        if (!done.contains(i)) {
          return {"skill": skill, "lesson": i};
        }
      }
    }
    return null;
  }

  static Future<void> resetAll() async {
    completedLessons.clear();
    lastSkill = null;
    lastLesson = null;
    await _save();
  }
}

// -------------------- MAIN APP --------------------
class SkillSprintApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SkillSprint',
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Color(0xFF1565C0),
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Color(0xFF1565C0),
            scaffoldBackgroundColor: Colors.black,
            brightness: Brightness.dark,
            cardColor: Colors.grey[900],
          ),
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/dashboard': (context) => DashboardPage(),
            '/profile': (context) => ProfilePage(),
            '/progress': (context) => ProgressPage(),
            '/skills': (context) => SkillsPage(),
            '/settings': (context) => SettingsPage(),
          },
        );
      },
    );
  }
}

// -------------------- LOGIN PAGE --------------------
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Center(
              child: Icon(Icons.school, size: 90, color: Color(0xFF1565C0)),
            ),
            SizedBox(height: 20),
            Center(
              child: Text("SkillSprint",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  )),
            ),
            SizedBox(height: 50),
            Text("Email", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password",
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1565C0),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

// -------------------- DASHBOARD PAGE --------------------
class DashboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {"icon": Icons.person, "title": "Profile", "route": "/profile"},
    {"icon": Icons.bar_chart, "title": "Progress", "route": "/progress"},
    {"icon": Icons.star, "title": "Skills", "route": "/skills"},
    {"icon": Icons.settings, "title": "Settings", "route": "/settings"},
  ];

  @override
  Widget build(BuildContext context) {
    final next = ProgressController.getNextLesson();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        elevation: 0,
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (next != null)
              Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Icon(Icons.play_arrow, color: Colors.orange, size: 40),
                  title: Text("Continue where you left off"),
                  subtitle: Text("${next['skill']} - Lesson ${next['lesson']}"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonPage(
                          skillTitle: next['skill'],
                          lessonNumber: next['lesson'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (context, index) {
                  return _buildFeatureCard(
                    context,
                    features[index]['icon'],
                    features[index]['title'],
                    features[index]['route'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String route) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Color(0xFF1565C0)),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// -------------------- PROFILE PAGE --------------------
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        title: Text("Profile", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 60, color: Color(0xFF1565C0)),
            ),
            SizedBox(height: 16),
            Text("Keziah Dorothy", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("keziahdorothy14@gmail.com", style: TextStyle(color: Colors.grey.shade600)),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.school, color: Color(0xFF1565C0)),
              title: Text("Current Skill Level: Beginner"),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Color(0xFF1565C0)),
              title: Text("Points Earned: 250"),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- PROGRESS PAGE --------------------
class ProgressPage extends StatelessWidget {
  ProgressPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final skills = LessonContent.lessons.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Progress", style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1565C0)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: skills.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, idx) {
            final s = skills[idx];
            final progress = ProgressController.getProgress(s);
            final done = ProgressController.completedLessons[s]?.length ?? 0;
            final total = ProgressController.lessonsPerSkill[s] ?? 0;
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress, color: const Color(0xFF1565C0), backgroundColor: Colors.grey.shade300, minHeight: 10),
                  const SizedBox(height: 6),
                  Text("${(progress * 100).toInt()}% completed — $done of $total lessons", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -------------------- SKILLS PAGE --------------------
class SkillsPage extends StatelessWidget {
  final List<Map<String, dynamic>> skills = ProgressController.lessonsPerSkill.keys
      .map((title) => {"title": title, "status": "Open"})
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        title: Text("Skills", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: skills.length,
          separatorBuilder: (_, __) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final skill = skills[index];
            final progress = ProgressController.getProgress(skill["title"]);
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: Icon(Icons.book, color: Color(0xFF1565C0), size: 32),
                title: Text(skill["title"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: LinearProgressIndicator(value: progress, color: Color(0xFF1565C0), backgroundColor: Colors.grey.shade300),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SkillDetailPage(skillTitle: skill["title"]),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(skill["status"], style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -------------------- SKILL DETAIL PAGE --------------------
class SkillDetailPage extends StatelessWidget {
  final String skillTitle;
  SkillDetailPage({required this.skillTitle});

  @override
  Widget build(BuildContext context) {
    final lessonCount = LessonContent.lessonCount(skillTitle);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        title: Text(skillTitle, style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("$skillTitle Lessons", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: lessonCount,
                itemBuilder: (context, index) {
                  final lessonNum = index + 1;
                  final lesson = LessonContent.getLesson(skillTitle, lessonNum);
                  final isDone = ProgressController.completedLessons[skillTitle]?.contains(lessonNum) ?? false;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.play_circle_fill, color: Color(0xFF1565C0)),
                      title: Text("$lessonNum. ${lesson['title']}"),
                      subtitle: Text(
                        lesson['description']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDone) Icon(Icons.check_circle, color: Colors.green),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LessonPage(skillTitle: skillTitle, lessonNumber: lessonNum),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- LESSON PAGE --------------------
class LessonPage extends StatefulWidget {
  final String skillTitle;
  final int lessonNumber;

  LessonPage({required this.skillTitle, required this.lessonNumber});

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    isCompleted = ProgressController.completedLessons[widget.skillTitle]?.contains(widget.lessonNumber) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final lesson = LessonContent.getLesson(widget.skillTitle, widget.lessonNumber);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        title: Text("${widget.skillTitle} - Lesson ${widget.lessonNumber}", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video placeholder (visual)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(Icons.play_circle_outline, size: 80, color: Color(0xFF1565C0)),
              ),
            ),
            SizedBox(height: 16),
            Text("${widget.lessonNumber}. ${lesson['title']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(lesson['description']!, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("Lesson Notes:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: SingleChildScrollView(
                  child: Text(lesson['notes']!, style: TextStyle(fontSize: 15)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: isCompleted
                    ? null
                    : () {
                  setState(() {
                    isCompleted = true;
                    ProgressController.completeLesson(widget.skillTitle, widget.lessonNumber);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lesson ${widget.lessonNumber} marked as completed!")),
                  );
                },
                icon: Icon(Icons.check),
                label: Text(isCompleted ? "Completed" : "Mark as Complete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.green : Color(0xFF1565C0),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
// -------------------- SETTINGS PAGE --------------------
class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings", style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1565C0)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDark,
            onChanged: (val) => themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light,
            activeColor: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text("Reset Progress"),
            subtitle: const Text("Clears all completed lessons (persistent)"),
            onTap: () async {
              await ProgressController.resetAll();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All progress has been reset")));
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF1565C0)),
            title: const Text("App Version: 1.0.0"),
          ),
        ]),
      ),
    );
  }
}
