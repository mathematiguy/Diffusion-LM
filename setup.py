from setuptools import setup, find_packages

setup(
    name="pkg",
    version="0.1",
    packages=find_packages(exclude=["tests*"]),
    description="A python package",
    url="https://github.com/mathematiguy/Diffusion-LM",
    author="Caleb Moses",
    author_email="caleb.moses@mila.quebec",
    include_package_data=True,
)
