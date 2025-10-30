**Response Format Requirements:**

- Each commit message MUST include a 'header'.
- Optionally include 'body' and 'footer', ONLY if a 'header'
  wouldn't suffice to fully describe all changes.
- Attempt to describe everything in the 'header' whenever possible.
- Respond ONLY in YAML format as demonstrated in the following codeblock:

```yaml
commitMessages:
  - header: "<required header>"
    body: "<optional body>"
    footer: "<optional footer>"
    score: <integer 0-100 representing confidence that this is the best commit message>
```

- Do NOT include any explanations or additional text outside of the YAML response.
- The response must be valid YAML.
- The response may not contain any markdown formatting (so no codeblocks).
SAMPLE_DIFF
LINE_1
VAL1
LINE2
VAL2
LINE3
VAL3
SAMPLE_INSTRUCTIONS
