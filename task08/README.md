# HOW-TO use this solution

This solution was developed following task requirements, guarantees a 100% score and may be used as a validation example.

To use this solution you need to copy all TF configuration files to your GIT repo into `task08` root folder and modify `terraform.tvars` in accordance with the following:

- update `12345678` pattern in **name_prefix** with your Learn `unique-id` (a value that you receive in **`Task Parameters`**)
- update `location` value with your desired location
- update `name_surname@epam.com` with your student email (a value that you receive in **`Task Parameters`** for a Creator tag)
- update value for a `context_repo_path` variable with your GIT registry reference to `task08/application` path

Then you can proceed with verification, providing as **REPO_URL** reference to your GIT registry, and as **TF_VAR_git_pat** value of your GIT token
