# Install pyenv
curl https://pyenv.run | bash

# Add pyenv init to shell startup file.
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# Note for the user to restart their shell.
echo "Please restart your shell or run 'source ~/.bashrc' to apply the changes."

# The following commands won't work until the new shell environment is sourced.
# Consider running them manually after restarting the shell, or automate with caution.
# pyenv install 3.12.2
# pyenv global 3.12.2