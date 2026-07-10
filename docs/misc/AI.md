[https://hiddenlayer.com/innovation-hub/novel-universal-bypass-for-all-major-llms/](https://hiddenlayer.com/innovation-hub/novel-universal-bypass-for-all-major-llms/)

- Understand how agentic AI works
- Recognize security risks from agent tools
- Exploit an AI agent
## Large Language Models (LLMs)
Large language models are the basis of many current AI systems. They are trained on massive collections of text and code, which allows them to produce human-like answers, summaries, and even generate programs or stories.
## Agentic AI
As mentioned, agentic AI refers to AI with agency capabilities, meaning that they are not restricted by narrow instructions, but rather capable of acting to accomplish a goal with minimal supervision. For example, an agentic AI will try to:

- Plan multi-step plans to accomplish goals.
- Act on things (run tools, call APIs, copy files).
- Watch & adapt, adapting strategy when things fail or new knowledge is discovered.
## Tool Use/User Space

Nowadays, almost any LLM natively supports function calling, which enables the model to call external tools or APIs. Here’s how it works:

Developers register tools with the model, describing them in JSON schemas as the example below shows:

```json
{
  "name": "web_search",
  "description": "Search the web for real-time information",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "The search query"
      }
    },
    "required": [
      "query"
    ]
  }
}
```

The above teaches the model: "There's a tool called web_search that accepts one argument: query." If the user asks a question, for example, "What's the recent news on quantum computing?", the model infers it needs new information. Instead of guessing, it produces a structured call, as displayed below:

```json
{  "name": "web_search",  "arguments": {    "query": "recent news on quantum computing"  }}
```

As the example above, the Bing or Google searches, and results are returned by the external system. The LLM then integrates the results into its reasoning trace, and the result of the above query can be something like:

" _The news article states that IBM announced a 1,000-qubit milestone…_"

We can observe a refined output, and the model produces a natural language answer to the user based on the tool's output. 

The use of AI in different fields has opened the door to new types of weaknesses. When an AI agent follows a process to complete its tasks, attackers can try to interfere with that process. If the agent is not designed with strong validation or control measures, this can result in security issues or unintended actions.
