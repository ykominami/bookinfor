```mermaid
flowchart TD
  _HTML-->GET_HTML-->PARSE_HTML-->HASH_TO_JSON_FILE;
  classDef Active fill:#1168bd,stroke:#0b4884,color:#ffffff
  class GET_HTML Active
```
```mermaid
graph TD;
_ALL-->CLEAN_ALL_FILES-->GET_HTML-->PARSE_HTML-->HASH_TO_JSON_FILE-->GET_AND_SAVE;
```
