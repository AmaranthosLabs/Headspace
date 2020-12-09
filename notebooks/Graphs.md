# Using Graphs...

## Basic Graphviz

### DOT Language is surrounded by delimiters

```graphviz
digraph Sample1 {
       A;
       B;
       A -> B;
}
```

### A Finite State Machine in GraphViz

```graphviz
digraph finite_state_machine {
    rankdir=LR;
    size="8,5"

    node [shape = doublecircle]; S;
    node [shape = point ]; qi

    node [shape = circle];
    qi -> S;
    S  -> q1 [ label = "a" ];
    S  -> S  [ label = "a" ];
    q1 -> S  [ label = "a" ];
    q1 -> q2 [ label = "ddb" ];
    q2 -> q1 [ label = "b" ];
    q2 -> q2 [ label = "b" ];
}
```

### More on [GraphViz](http://www.graphviz.org/) and [the DOT Language](http://www.graphviz.org/doc/info/lang.html)

[The DOT language](https://en.wikipedia.org/wiki/DOT_(graph_description_language)) was developed by AT&T and is Open Source

## Other Charts

### Mermaid

[Mermaid](https://mermaid.ink/) adds several charting capabilities...

#### Class Diagrams

```mermaid
classDiagram
    
    Animal <|-- Duck
    Animal <|-- Fish
    Animal <|-- Zebra
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    
    class Duck{
      +String beakColor
      +swim()
      +quack()
    }
    
    class Fish{
      -int sizeInFeet
      -canEat()
    }

    class Zebra{
      +bool is_wild
      +run()
    }
```

#### Decision/Flow Charts

```mermaid
graph TD
    A[Christmas] -->|Get money| B(Go shopping)
    B --> C{Let me think}   
    C -->|One| D[Laptop]
    C -->|Two| E[iPhone]
    C -->|Three| F[fa:fa-car Car]
```