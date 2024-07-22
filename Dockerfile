# syntax=docker/dockerfile:1

# Start from a core stack version
FROM quay.io/jupyter/datascience-notebook:latest

# Switch to root to install module dependencies
USER root
USER jovyan

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/requirements.txt
RUN mamba install --yes --file /tmp/requirements.txt && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN mamba install --yes 'jupyterlab-spellchecker' 'black' 'isort' 'jupyterlab-lsp' 'python-lsp-server[all]' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir 'jupyterlab-code-formatter' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
