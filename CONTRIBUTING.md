# Contributing

First off, let me thank you for considering contributing to this project!
Your help is greatly appreciated.

> ℹ️ Don't know how to contribute? Feel free to open an issue,
> and I can guide you through the process.

## How to Contribute

This project is built with [Bashly](https://bashly.dev/), a tool for building
Bash CLI applications. Refer to the Bashly website to learn more about how
the structure of a Bashly project works.

### Contributing (to) default prompts and variables

If you want to contribute new default prompts or variables, please follow these steps:

1. Fork the repository and clone it to your local machine.
2. Create a new branch for your changes.
3. If you want to add change the default prompt or change the variables of an existing
   commit standard, say `conventional-commits`:
   1. Navigate to the `defaults/prompts/conventional-commits/`
      directory.
   2. Then alter the prompt or variables file in
      `defaults/prompts/conventional-commits/default.md` and `defaults/prompts/conventional-commits/default-vars.yaml`

   If you want to add a new variation of an existing commit standard, say
   `conventional-commits` with a variation called `my-variation`:
   1. Navigate to the `defaults/prompts/conventional-commits/`
      directory.
   2. Create new prompt and variable files named
      `my-variation.md` and `my-variation-vars.yaml` respectively.
   3. Populate these files with the appropriate content for your new variation.

   If you want to add a completely new commit standard:
   1. Create a new directory under `defaults/prompts/` with the name of your
      new commit standard. e.g. `my-commit-standard`
   2. Inside that directory, create two files:
      - `default.md`: This file should contain the default prompt in Markdown format.
      - `default-vars.yaml`: This file should contain the default variables
        in YAML format.
   3. Populate these files with the appropriate content for your new commit standard.

4. After making your changes, run the test suite to ensure everything is working
   correctly. (see the [Testing Your Changes](#testing-your-changes) section below)
5. If you have added a new commit standard or variation:
   - create some tests for it. A good place would be the
     `spec/render_prompt_spec.sh` file.
   - consider updating the documentation to include information about your addition.

### Generating a new release

To generate a new release of `cfme`, run `bashly generate` to regenerate the
`cfme` script with the latest changes, based on the changes in `src`.

Then

```bash
rm release/cfme
mv cfme release/cfme
# Make sure the release script is not executable by default
chmod -x release/cfme
```

## Testing Your Changes

Generate a new version of the `cfme` script by running:

```bash
bashly generate
```

This script needs to be at the root of the directory for the tests to run correctly.

`cfme` uses [Shellspec](https://shellspec.info/) for testing. To run the test suite,
make sure you have Shellspec installed, then run, from the root of the repository:

```bash
shellspec --shell bash
```

Refer to the Shellspec documentation for more details on writing and running tests.

Getting stuck or need help writing tests? Feel free to open an issue.
If you open up a PR without tests, please mention that clearly in the description.

## Submitting Your Changes

Once you are satisfied with your changes and have tested them, you can submit
them for review:

1. If you haven't already, open up an issue describing what you plan to change.
2. Push your branch to your forked repository.
3. Open a Pull Request (PR) against the `main` branch of this repository.
4. Provide a clear description of the changes you have made and any relevant
   information for the reviewers.
5. Mention the related issue number (e.g. `Closes #123`).

Done! Your contribution will be reviewed, and if everything looks good,
it will be merged into the main codebase.
Thank you for helping to improve this project!
