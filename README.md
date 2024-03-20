# IOb-SoC-Tester

IOb-SoC-Tester is a platform for developing and validating hardware/software (HW/SW) algorithms. This platform utilizes RISC-V CPUs and peripherals called Test Instruments (TIs).

This project initially started with the [OpenCryptoTester](https://nlnet.nl/project/OpenCryptoTester#ack) to mainly to verify cryptographic systems that improve internet security. However, IOb-SoC Tester can also be used to test any Core or SoC. The proposed tester SoC shoud open the way for open-source test instrumentation operated bare-metal or under Linux.

# Repository moved

### The new Tester contents along with up-to-date instructions and an example System Under Test (SUT) are available at the [IOb-SoC-SUT](https://github.com/IObundle/iob-soc-sut) repository.

# Brief development history

This repository used to contain a Tester SoC based on [IOb-SoC](https://github.com/IObundle/iob-soc) until its functionality was merged into the IOb-SoC system itself.

The Tester consists of an SoC derived from IOb-SoC and contains a set of IOb-SoC-compatible peripherals to be used as verification tools.

Each peripheral provides a new interface to the Tester, allowing it to connect, control and monitor the IOs of the Unit Under Test (UUT).

The Tester used to be a standalone SoC using a Makefile-based setup and build system.
However, as many of the Tester components are shared with IOb-Soc, those components were removed from the Tester system, and are instead sourced from the IOb-SoC repository.
The IOb-SoC repository is usually added as a git submodule for easier version control.

Currently the IObundle projects use a Python-based Object Oriented setup process, that allows for easier integration of components and creation of component derivations.

The new Tester used in the [IOb-SoC-SUT](https://github.com/IObundle/iob-soc-sut) repository is a subclass of IOb-SoC that creates a derivation of that system.
It also contains the specialized tools required to verify that System Under Test (SUT).

The Tester system is compatible with any Unit Under Tester (UUT) as it does not impose any hardware constraints.
For instructions on how to set up the Tester with a generic UUT, see [this section](https://github.com/IObundle/iob-soc-sut#instructions-to-configure-the-opencryptotester-with-a-generic-uut).

# Acknowledgement

First of all, we acknowledge all the volunteer contributors for all their valuable pull requests, issues, and discussions. 

The [OpenCryptoTester](https://nlnet.nl/project/OpenCryptoTester#ack) project is funded through the NGI Assure Fund, a fund established by NLnet
with financial support from the European Commission's Next Generation Internet
programme, under the aegis of DG Communications Networks, Content and Technology
under grant agreement No 957073.

<table>
    <tr>
        <td align="center" width="50%"><img src="https://nlnet.nl/logo/banner.svg" alt="NLnet foundation logo" style="width:90%"></td>
        <td align="center"><img src="https://nlnet.nl/image/logos/NGIAssure_tag.svg" alt="NGI Assure logo" style="width:90%"></td>
    </tr>
</table>

The work has been partially performed in the scope of the A-IQ Ready project, which receives funding within Chips Joint Undertaking (Chips JU) - the Public-Private Partnership for research, development, and innovation under Horizon Europe – and National Authorities under grant agreement No. 101096658.

The A-IQ Ready project is supported by the Chips Joint Undertaking (Chips JU) - the Public-Private Partnership for research, development, and innovation under Horizon Europe – and National Authorities under Grant Agreement No. 101096658.

![image](https://github.com/IObundle/iob-soc/assets/5718971/78f2a3ee-d10b-4989-b221-71154fe6e409) ![image](https://github.com/IObundle/iob-soc/assets/5718971/d57e0430-bb60-42e3-82a3-c5b6b0417322)
