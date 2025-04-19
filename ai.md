# AI - Artificial Intelligence

These are _"Narrow AI"_ - specialized for specific tasks only.

AGI - _"Artificial General Intelligence"_ - mirroring everything humans can do - is not real yet.

<!-- INDEX_START -->

- [Learning](#learning)
- [Run AI with API](#run-ai-with-api)
- [Chat](#chat)
  - [ChatGPT](#chatgpt)
  - [Deepseek](#deepseek)
  - [Grok](#grok)
  - [Meta AI](#meta-ai)
  - [Perplexity](#perplexity)
  - [SQL Chat](#sql-chat)
  - [LLM](#llm)
    - [Ollama](#ollama)
- [Text to Speech](#text-to-speech)
- [Speech to Text](#speech-to-text)
  - [Otter.ai](#otterai)
  - [OpenAI Whisper](#openai-whisper)
    - [OpenAI Whisper Install](#openai-whisper-install)
    - [OpenAI Whisper Run CLI](#openai-whisper-run-cli)
    - [OpenAI Whisper Run from Python](#openai-whisper-run-from-python)
- [Grammar](#grammar)
- [Visual](#visual)
  - [Image](#image)
  - [Video](#video)
- [UI](#ui)
- [App Generation](#app-generation)
- [Coding](#coding)
- [RAG - Retrieval Augmented Generation](#rag---retrieval-augmented-generation)
- [Debugging](#debugging)
- [List of AI Tools By Categories](#list-of-ai-tools-by-categories)
- [Meme](#meme)
  - [LLM - How to Plagiarize Like a Pro](#llm---how-to-plagiarize-like-a-pro)
  - [Building AI to Replace Humans](#building-ai-to-replace-humans)
  - [Fewer Devs, Fewer Managers](#fewer-devs-fewer-managers)
- [Copying and Pasting from ChatGPT](#copying-and-pasting-from-chatgpt)
  - [Say Powered by AI One More Time](#say-powered-by-ai-one-more-time)
  - [Coding with GPT](#coding-with-gpt)
- [My Code Stack Overflow, ChatGPT](#my-code-stack-overflow-chatgpt)

<!-- INDEX_END -->

## Learning

<https://www.cloudskillsboost.google/paths/118>

## Run AI with API

- [Replicate](https://replicate.com/)

## Chat

### ChatGPT

<https://chat.openai.com/chat>

### Deepseek

<https://chat.deepseek.com/>

### Grok

By Elon / X:

<https://x.com/i/grok>

### Meta AI

<https://www.meta.ai/>

### Perplexity

<https://www.perplexity.ai/>

### SQL Chat

- [SQL Chat](https://github.com/sqlchat/sqlchat) - chat-based interface to querying DBs

### LLM

#### Ollama

<https://www.ollama.com>

<https://github.com/ollama/ollama>

Ollama Open WebUI + engine which is prompt-based, similar to ChatGPT, ask questions, get responses.
It's completely local, it doesn't go to the internet.

Engine nodes run on GPUs.

The query response is very slow and prints a few words a second when using CPUs instead of GPUs.

Performance decline after consecutive questions.

Why does the performance degrade after one query?

## Text to Speech

- [ElevenLabs](https://elevenlabs.io)

## Speech to Text

### Otter.ai

<https://otter.ai/>

Proprietary subscription, not bothering with it, used OpenAI Whisper below for free instead.

### OpenAI Whisper

[:octocat: openai/whisper](https://github.com/openai/whisper)

#### OpenAI Whisper Install

Installs locally, downloads a model and runs on a local video or audio file.

Install on Mac:

```shell
brew install openai-whisper
```

or generic Python install

```shell
pip install openai-whisper
```

Also requires `ffmpeg` to be installed.

On Mac:

```shell
brew install ffmpeg
```

or on Debian / Ubuntu Linux:

```shell
sudo apt update &&
sudo apt install ffmpeg -y
```

#### OpenAI Whisper Run CLI

List of [Available Models](https://github.com/openai/whisper#available-models-and-languages).

Run whisper, using the `--turbo` model (will take a while to download the model the first time):

```shell
whisper "$file" --turbo
```

Outputs the text transcript from the video or audio file to stdout,
as well as creating `.txt`, `.srt`, `.json`, `.tsv` and `.vtt` formatted transcripts for further processing.

#### OpenAI Whisper Run from Python

```python
import whisper

model = whisper.load_model("turbo")
result = model.transcribe("audio.mp3")
print(result["text"])
```

## Grammar

- [Grammarly](https://app.grammarly.com>)
- [HemingwayApp](https://hemingwayapp.com)

## Visual

### Image

<https://www.meta.ai/>

### Video

- [InVideo AI](https://invideo.io/) - generate high production quality videos from text prompts
- [LumaLabs Dream Machine](https://lumalabs.ai/dream-machine) - pics or video

<!--

#### Translate Video

<https://clideo.com/translate-instagram-video>

#### Translate Video on Instagram

<https://videotranslator.blipcut.com/instagram-video-translator.html>

-->

## UI

- [Uizard](https://uizard.io) - <https://app.uizard.io>

## App Generation

- [Lovable](https://lovable.dev/) - Idea to app in seconds

## Coding

- [GitHub CoPilot](https://github.com/features/copilot)
- [TabNine](https://www.tabnine.com) - support for all major IDEs including my favourite [IntelliJ](intellij.md)
- [Cursor AI](https://www.cursor.com) - separate Editor that requires download, limited completions in free edition
- [Agentic](https://www.agentic.ai/)
- [Windsurf](https://windsurf.com/editor)

## RAG - Retrieval Augmented Generation

Combines LLM with referencing an authoritative traditional Knowledge Base before it answers.

<https://www.promptingguide.ai/techniques/rag>

<https://blogs.nvidia.com/blog/what-is-retrieval-augmented-generation/>

<https://cloud.google.com/use-cases/retrieval-augmented-generation?hl=en>

<https://aws.amazon.com/what-is/retrieval-augmented-generation/>

<https://learn.microsoft.com/en-us/azure/search/retrieval-augmented-generation-overview>

## Debugging

- [:octocat: robusta-dev/holmesgpt](https://github.com/robusta-dev/holmesgpt)

## List of AI Tools By Categories

![List of AI Tools by Categories](images/list-of-ai-tools-by-categories.webp)

## Meme

### LLM - How to Plagiarize Like a Pro

![LLM How to Plagiarize Like a Pro](images/orly_llm_how_to_plagiarize_like_a_pro.png)

### Building AI to Replace Humans

![Building AI to Replace Humans](images/orly_building_ai_to_replace_humans.png)

### Fewer Devs, Fewer Managers

![Fewer Devs, Fewer Managers](images/fewer_devs_fewer_managers.jpeg)

## Copying and Pasting from ChatGPT

![Copying and Pasting from ChatGPT](images/orly_copying_pasting_chatgpt.jpeg)

### Say Powered by AI One More Time

![Say Powered By AI One More](images/say_powered_by_AI_one_more_time.jpeg)

### Coding with GPT

Watch out for that quality and not knowing WTF you're doing!

![Coding with GPT](images/orly_book_coding_with_gpt.jpeg)

## My Code Stack Overflow, ChatGPT

![My Code Stack Overflow ChatGPT](images/my_code_stack_overflow_chatgpt.jpeg)
