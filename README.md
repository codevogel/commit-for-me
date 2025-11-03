# cfme

Commit for me! 🤖 Generate commit messages using aichat.

Uses the conventional-commits standard by default, but is easily customizable
to your own needs.

Just run `cfme` after staging your changes, and it will generate a commit message
using AI, prompt you to review and edit it, then commit it for you.

## Demo 🎥

![cfme demo](./demo/demo.gif)

> There is also a demo available showing how to use `cfme` from within
> [Lazygit](https://github.com/jesseduffield/lazygit/).
> Jump to the [Lazygit Integration](#lazygit) section below.

## Features ✨

- **AI-Powered Commit Messages** - Leverages modern AI models
  (OpenAI GPT, GitHub Copilot) to analyze your staged changes and generate
  meaningful commit messages
- **Interactive Review & Selection** - Uses `fzf` to let you choose from
  multiple AI-generated candidates, then edit before committing
- **Conventional Commits by Default** - Follows the
  [conventional-commits](https://www.conventionalcommits.org/) standard
  out of the box for consistent, parseable commit history
- **Fully Customizable** - Bring your own prompts, variables, and commit
  message standards - cfme adapts to your team's workflow
- **Template-Based Prompts** - Simple `<__MY_VARIABLE__>` syntax for injecting
  git diffs, test results, custom instructions, or any command output into your prompts
- **Multiple Prompt Types** - Switch between different commit message standards
  (conventional-commits, your-team-standard, etc.) with a single environment variable
- **Runtime Instructions** - Pass specific context with `-i "Fixed login bug"`
  to guide the AI without editing prompt files
- **Pipe-Friendly Output** - Use `-r` or `-m` flags to output messages for
  integration with other tools and workflows
- **Free Tier Available** - Works with GitHub Copilot's free tier (everyone
  with a GitHub account has access)
- **Cross-Platform** - Works on macOS, Linux, and Windows (via WSL/Git Bash/Cygwin)
- **Tested** - Uses [Shellspec](https://github.com/shellspec/shellspec)
  unit tests to ensure reliability and correctness

## Quick Start 🚀

1. **Install dependencies**:
   - [aichat](https://github.com/sigoden/aichat?tab=readme-ov-file#install)
   - [fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#installation)
   - [yq](https://github.com/mikefarah/yq?tab=readme-ov-file#install)

   e.g. using [Homebrew/Linuxbrew](https://brew.sh/) `brew install aichat fzf yq`

2. **Install `cfme`**:

   ```bash
   curl -sSL https://github.com/codevogel/cfme/releases/download/latest/cfme
   chmod +x cfme
   sudo mv cfme /usr/local/bin # or any directory, as long as it's in your $PATH
   ```

3. **Setup `aichat` credentials** (just run `aichat` and follow the prompts)

   > ℹ️ Note: You can get your GitHub 'API Key' by creating a
   > [Personal Access Token (classic)](https://github.com/settings/tokens)
   > with `Copilot` scope.

4. **Stage some changes**: `git add .`

5. **Run `cfme` to generate commit message**: `cfme`

<!-- markdownlint-disable MD036 -->
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents**

- [cfme](#cfme)
  - [Features ✨](#features-)
  - [Demo 🎥](#demo-)
  - [Quick Start 🚀](#quick-start-)
  - [Usage](#usage)
    - [Examples](#examples)
  - [Customization](#customization)
    - [Writing a custom prompt file](#writing-a-custom-prompt-file)
    - [Writing a variables file](#writing-a-variables-file)
    - [Environment Variables](#environment-variables)
  - [Integration into other tools](#integration-into-other-tools)
    - [Lazygit](#lazygit)
    - [Other tools](#other-tools)
  - [Contributing](#contributing)
  - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
<!-- markdownlint-restore MD036 -->

## Usage

```txt
cfme [OPTIONS]
cfme --help | -h
cfme --version
```

<!-- markdownlint-disable MD013 -->

| Option                  | Short    | Argument       | Description                                                                                                                                                            | Notes                       |
| ----------------------- | -------- | -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `--instructions`        | `-i`     | `INSTRUCTIONS` | An optional brief set of instructions to pass the AI, to help it generate commit message candidates. Replaces template string `<__INSTRUCTIONS__>` in the prompt file. |                             |
| `--prompt-file`         | `-p`     | `FILE_PATH`    | Overrides the default prompt by reading from a specified file.                                                                                                         |                             |
| `--variables-file`      | `-v`     | `FILE_PATH`    | Overrides path for the prompt variables file (`$CFME_PROMPT_VARIABLES_FILE`) by reading from a specified file.                                                         |                             |
| `--response`            | `-r`     | _(none)_       | Prints the direct response from the AI, instead of prompting to review response and then committing. Used for piping the response into other tools.                    | Conflicts with `--message`  |
| `--message`             | `-m`     | _(none)_       | Prints the reviewed commit message instead of committing. Used for piping the reviewed message into other tools.                                                       | Conflicts with `--response` |
| `--silent`              | `-s`     | _(none)_       | Suppresses all non-error output. Also possible through the `$CFME_SILENT_MODE` environment variable.                                                                   |                             |
| `--print-parsed-prompt` | _(none)_ | _(none)_       | Prints the parsed prompt after replacing template strings with variable values, then exits. Useful for debugging.                                                      |                             |

### Examples

| Command                                                                  | Description                                                                                                                                                                        |
| ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `cfme`                                                                   | Generate, review, and commit using the defaults.                                                                                                                                   |
| `cfme -i "Fix issue with user login"`                                    | Overrides the `<__INSTRUCTIONS__>` template string — useful for helping the AI figure out what message to generate.                                                                |
| `cfme -p "./my-custom-prompt.md"`                                        | Overrides the default prompt file.                                                                                                                                                 |
| `cfme -v "./my-custom-variables.yaml"`                                   | Overrides the default variables file.                                                                                                                                              |
| `cfme -m`                                                                | Generates and reviews a commit message, but echoes it instead of committing.                                                                                                       |
| `cfme -rs`                                                               | Generates a response to the prompt, then echoes the raw response instead of reviewing and committing, suppressing all non-error output.                                            |
| `cfme -si "<Instructions>" -p "./my-prompt.md" -v "./my-variables.yaml"` | Generates a raw response to the prompt, replacing the `<__INSTRUCTIONS__>` template string, using a custom prompt file and variables file, while suppressing all non-error output. |

<!-- markdownlint-restore MD013 -->

## Installation

The [Quick Start](#quick-start-) section above provides a quick way to setup `cfme`.
What follows is a more detailed explanation of the installation process.

1. **Install dependencies**:

   `cfme` depends on the following command-line tools. Please refer to their
   respective installation instructions for your platform.
   - [aichat](https://github.com/sigoden/aichat?tab=readme-ov-file#install)
     - This serves as the interface to various AI chat models, including
       OpenAI's GPT models and GitHub Copilot.
   - [fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#installation)
     - This is used to provide an interactive fuzzy search interface to
       select from the commit message candidates generated by the AI.
   - [yq (from mikefarah)](https://github.com/mikefarah/yq?tab=readme-ov-file#install)
     - This is used to parse the YAML variables file for use in the prompt.
     - Note: There are two popular `yq` tools, make sure to install the one from
       mikefarah, as the syntax differs between the two, and you might run into
       issues otherwise.

   [Brew](https://brew.sh/) is a convenient way to install all of the dependencies
   on macOS and Linux, but feel free to use any other method you prefer.

   ```bash
   brew install aichat fzf yq
   ```

2. **Install `cfme`**:
   Download the latest release binary from the
   [Releases](https://github.com/codevogel/cfme/releases) page,
   make it executable, and move it to a directory in your `$PATH`.

   **On Unix-like systems**, you can do this with the following commands:

   ```bash
   curl -sSL https://github.com/codevogel/cfme/releases/download/latest/cfme
   chmod +x cfme
   sudo mv cfme /usr/local/bin # or any directory, as long as it's in your $PATH
   ```

   **On Windows**, it is important to know that `cfme` is a shell script written
   in `bash`, so you will need to have a `bash` environment set up, e.g. through
   [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) or,
   Git Bash (which comes with [Git](https://git-scm.com/install/windows)),
   [Cygwin](https://www.cygwin.com/),
   [mingw-64](https://www.mingw-w64.org/) etc.

3. **Setup `aichat` credentials**:
   Run `aichat` and follow the prompts to set up your AI chat model and API Key.
   - For GitHub Copilot, you can get your 'API Key' by creating a
     [Personal Access Token (classic)](https://github.com/settings/tokens).
     Be sure to give this token the `Copilot` scope.
     Everyone who has a GitHub account has access to the GitHub Copilot Free plan.
     You may hit limits with this plan, however.

     Educators, students, and open source contributors may be eligible for
     **free** access to GitHub Copilot Pro. See [this page](https://docs.github.com/en/copilot/get-started/plans)
     for more information.

   - `aichat` supports a bunch of different AI providers, such as OpenAI GPT,
     Claude, and more.
   - Choose a model wisely: For example, GPT-4 mini generates faster commit message
     faster, whereas GPT-4 probably writes more accurate messages.

4. **Stage some changes**:
   `cfme` generates commit messages based on the _staged_ changes in your git repository.
   Note that changed files aren't yet staged, so you need to stage them first using
   `git add <file>`.
   (You can optionally alter your prompt to include unstaged changes if you want
   to, see the '[Customization](#customization)' section below for more information.)

5. **Run `cfme` to generate commit message**:
   Simply run `cfme` in your terminal while in the git repository with staged changes.
   Follow the prompts to review and edit the generated commit message, then
   confirm to commit it.

   Be sure to check out the '[Customization](#customization)' section below
   to learn how to customize the prompt and variables to your own needs,
   and check out the '[Usage](#usage)' section to learn about the available options,
   such as passing instructions to the AI on what the commit is about, piping
   the output to other tools, and more.

## Customization

Not happy with the default prompt or variables?

`cfme` is designed to be customizable to your needs.

Simply create your own prompt at `$CFME_CONFIG_DIR/$CFME_PROMPT_DIR/$CFME_PROMPT_TYPE/<your-prompt>.md`
and/or your own variables file at `$CFME_CONFIG_DIR/$CFME_PROMPT_DIR/$CFME_PROMPT_TYPE/<your-variables>.yaml`.
then set `$CFME_DEFAULT_PROMPT_FILE` and/or `$CFME_PROMPT_VARIABLES_FILE` to
point to your custom files, or use the `-p` and `-v` flags to specify them at runtime.

`$CFME_PROMPT_TYPE` will determine the subdirectory in the `$CFME_PROMPT_DIR`
directory by default, allowing you to quickly switch between different prompt
types (e.g. `conventional-commits`, or any other standard your team uses).

**Example:**

1. Say you want to create a custom prompt for your own commit message standard,
   you could do the following:
   - Prompt file: `~/.config/cfme/prompts/my-commit-standard/default.md`
   - Variables file: `~/.config/cfme/prompts/my-commit-standard/default-vars.yaml`
   - Environment variables:

   ```bash
   export CFME_PROMPT_TYPE="my-commit-standard"
   ```

   Or just use the flags:

   ```bash
   cfme -p "path/to/custom/prompt.md" -v "path/to/custom/vars.yaml"
   ```

2. Say you want to use the `conventional-commits` standard, but with your own custom
   prompt and variables, you could do the following:
   - Prompt file: `~/.config/cfme/prompts/conventional-commits/my-custom-prompt.md`
   - Variables file: `~/.config/cfme/prompts/conventional-commits/my-custom-vars.yaml`
   - Environment variables:

     ```bash
     export CFME_DEFAULT_PROMPT_FILE="$CFME_PROMPT_DIR/$CFME_PROMPT_TYPE/my-custom-prompt.md"
     export CFME_PROMPT_VARIABLES_FILE="$CFME_PROMPT_DIR/$CFME_PROMPT_TYPE/my-custom-vars.yaml"
     ```

     Or just use the flags:

   ```bash
   cfme -p "path/to/custom/prompt.md" -v "path/to/custom/vars.yaml"
   ```

> ℹ️ If the specified `$CFME_DEFAULT_PROMPT_FILE` or `$CFME_PROMPT_VARIABLES` file
> does not yet exist, `cfme` will attempt to fetch these files from the `/defaults`
> folder in this repository. This requires `$CFME_PROMPT_TYPE` to be set to the default
> value of `conventional-commits`. See the 'Environment Variables' section below
> for more information.

### Writing a custom prompt file

`cfme` uses a prompt file in markdown format, in which you can write your prompt
that will be sent to the AI.

`cfme` will parse your prompt file, replacing any template strings in the format
of `<__MY_TEMPLATE_STRING__>` with the corresponding values from your variables file.

There are three special template strings that `cfme` recognizes by default:

- `<__GIT_DIFF__>` (required): Replaced with the output of `git diff --cached`
  (i.e. the staged changes)
- `<__RESPONSE_FORMAT_REQUIREMENTS__>` (required): Replaced with a list of requirements
  that dictates how the AI should format its response. This is essential so
  that `cfme` can parse the AI's response.
  Note that these requirements merely dictate the format of the response, they
  do not influence the requirements for the commit message itself.
- `<__INSTRUCTIONS__>` (optional): Replaced with any instructions passed via the
  \[-i|--instructions\] flag.
  - If no instructions are provided, this template string is replaced with an
    empty string.
  - You can leave out this template string from your prompt file if you don't
    plan to use it.

> ℹ️`cfme` will warn you if you have template strings in your prompt file that
> are not defined in your variables file, and vice versa, it will warn you if
> you have variables defined that are not used in your prompt file.

For example, the simplest prompt file could look like this:

```txt
Generate a commit message for the following changes:
<__GIT_DIFF__>
<__RESPONSE__REQUIREMENTS__>
```

A more complex prompt file could look like this:

```txt
You are an expert software developer who writes clear and concise commit messages.
Your task is to generate a commit message based on the following instructions,
if present:
<__INSTRUCTIONS__>
The commit message should follow these guidelines:
<__COMMIT_MESSAGE_GUIDELINES__>
Here are the changes that need to be committed:
<__GIT_DIFF__>
Generate <__NUM_COMMIT_MESSAGES__> commit message candidates that adheres to the
above guidelines.
Here are the test results for the changes:
<__TEST_RESULTS__>
<__RESPONSE__REQUIREMENTS__>
```

See below for how to write the corresponding variables file.

### Writing a variables file

The variables file is a simple YAML file that defines key-value pairs
for use in your prompt file.
You can either define literal strings (single or multi-line), or
command (sequences) that will be evaluated, and their output used as the value.

A valid variables file must have a top-level key `vars`, which contains
an array of variable definitions.

A variable definition

- must have a `template_string` key, which defines the
  template string to be replaced in the prompt file (including the `<__` and
  `__>` delimiters).
- must have either a
  - `value` key, which defines the literal string value to replace the
    template string with, or
  - `value_from` key, which defines a command (sequence) to be executed.
    The output of those commands is used as the value to replace the template
    string with.

For example, the variables file corresponding to the above complex prompt
could look like this:

```yaml
vars:
  - template_string: "<__COMMIT_MESSAGE_GUIDELINES__>"
    value: |
      - Use the imperative mood in the subject line.
      - Limit the subject line to 50 characters.
      - Wrap the body at 72 characters.
      - Use the body to explain what and why vs. how.
  - template_string: "<__NUM_COMMIT_MESSAGES__>"
    value: "3"
  - template_string: "<__TEST_RESULTS__>"
    value_from: "pnpm test:unit --reporter=summary"
```

> ℹ️ If you want to do so, you can use define default `<__INSTRUCTIONS__>`
> variable in your variables file, which you can overwrite by passing the
> \[-i|--instructions\] flag at runtime.
> You can also just leave out the `<__INSTRUCTIONS__>` template string
> from the variables file, and `cfme` will replace it with an empty string
> if no instructions are provided at runtime.

### Environment Variables

`cfme` supports the following environment variables for configuration:

```bash
CFME_CONFIG_DIR
    default: ${XDG_CONFIG_HOME:-$HOME/.config}/cfme
    help: Directory to store configuration files for Commit For Me
CFME_PROMPT_DIR
    default: ${CFME_CONFIG_DIR}/prompts
    help: Directory to store prompt files for Commit For Me
CFME_PROMPT_TYPE
    default: conventional-commits
    help: The default subfolder to process prompts from.
CFME_DEFAULT_PROMPT_FILE
    default: ${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md
    help: Path to the default prompt file for generating commit messages
          (overridden by --file flag)
CFME_DEFAULT_PROMPT_VARIABLES_FILE
    default: ${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml
    help: Path to the file containing prompt variables.
CFME_SILENT_MODE
    default: "false"
    help: If set to true, suppresses all non-error output.
          (the [-s|--silent] flag does the same)
```

Recommendations:

- keep CFME_CONFIG_DIR and CFME_PROMPT_DIR at their default values,
  unless you have a specific reason to change them.
- set CFME_PROMPT_TYPE to the prompt type you want to use by default
  (e.g. `conventional-commits`), if you have multiple prompt types set up.
  (see [Customization](#customization) section above for more information)
- keep the structure of CFME_DEFAULT_PROMPT_FILE and
  CFME_DEFAULT_PROMPT_VARIABLES_FILE as is, (i.e. keep the
  `${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/` prefix)

For advanced users, you can also set where `cfme` fetches the default files
from, should they not exist on your system. This requires `$CFME_PROMPT_TYPE`
to be set something other than `conventional-commits`.
This is useful if you maintain your own fork with custom default prompts you want
to use.

```bash
CFME_DEFAULT_PROMPT_FILE_FETCH_URL
    default: https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default.md
    help: URL used to fetch the default prompt file if it does not exist locally.
CFME_DEFAULT_PROMPT_VARIABLES_FILE_FETCH_URL
    default: https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default-vars.yaml
    help: URL used to fetch the default prompt variables file if
          it does not exist locally.
```

## Integration into other tools

### Lazygit

[Lazygit](https://github.com/jesseduffield/lazygit) is awesome.
But `cfme` allows you to be even lazier! You can use `cfme`
from within Lazygit's TUI to generate commit messages:

![cfme lazygit demo](./demo/lazygit-demo.gif)

Just add the following custom command to your Lazygit config file
(e.g. `~/.config/lazygit/config.yml`):

```yaml
customCommands:
  - key: "<c-a>"
    description: "generate message candidates and commit using cfme"
    command: "cfme"
    context: "files"
    loadingText: "Generating commit message with cfme..."
    subprocess: true
```

And now, use lazygit to stage your changes, then just press `Ctrl+a`
to run `cfme` and generate a commit message for the staged changes!

### Other tools

As `cfme` is just a bash script, you can easily integrate it into
other tools and workflows.
Have a look at the [Lazygit](#lazygit) section above for an example
of how to do this.

The `-r` and `-m` flags are especially interesting for integration
into other tools, as they allow you to pipe the AI-generated
response or the reviewed commit message into other tools, instead
of committing it directly.

The `-p` and `-v` flags allow you to specify custom prompt
and variables files, which is useful if you want to have
different prompts for different workflows.

I'm sure you can come up with many more use cases!
If you ever get stuck integrating `cfme` into your workflow,
or if you need an additional feature to make the integration easier,
feel free to ask for help. Just open up an issue!

## Contributing

If you would like to contribute to this project, you're more than welcome
to do so!
Feel free to open up issues or submit pull requests.

Example contributions include:

- Wrote a prompt that you think delivers awesome results? Share it as a
  new prompt type!
- Found a way to improve the default prompt or variables? Submit a PR!
- Added a new feature or fixed a bug? Pull request welcome!
- Want to improve the documentation? Contributions are welcome!

See [CONTRIBUTING.md](./CONTRIBUTING.md) for more information on how to contribute.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
