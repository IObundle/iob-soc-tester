# OpenCryptoTester

The [OpenCryptoTester](https://nlnet.nl/project/OpenCryptoTester#ack) project aims to develop a System-on-Chip (SoC) used mainly to verify cryptographic systems that improve internet security but can also be used on any SoC. It is synergetic with several other NGI Assure-funded open-source projects - notably [OpenCryptoHW](https://nlnet.nl/project/OpenCryptoHW) (Coarse-Grained Reconfigurable Array cryptographic hardware) and [OpenCryptoLinux](https://nlnet.nl/project/OpenCryptoLinux). The proposed SoC will support test instruments as peripherals and use OpenCryptoHW as the System Under Test (SUT), hopefully opening the way for open-source test instrumentation operated under Linux.

# Repository moved

### The new Tester contents along with up-to-date instructions and an example System Under Test are available at the [IOb-SoC-SUT](https://github.com/IObundle/iob-soc-sut) repository.

# Brief development history

This repository used to contain a Tester SoC based on [IOb-SoC](https://github.com/IObundle/iob-soc) until its functionality was merged into the IOb-SoC system itself.

The Tester consists of an SoC derived from IOb-SoC and contains a set of IOb-SoC-compatible peripherals to be used as verification tools.

Each peripheral provides a new interface to the Tester, allowing it to connect, control and monitor the IOs of the Unit Under Test (UUT).

The Tester used to be a standalone SoC using a Makefile-based setup and build system.
However, as many of the Tester components are shared with IOb-Soc, those components were removed from the Tester system, and are instead sourced from the IOb-SoC repository.
The IOb-SoC repository is usually added as a git submodule for easier version control.

Currently the IObundle projects use a Python-based Object Oriented setup process, that allows for easier integration of components and creation of component derivations.

The new Tester used in the [IOb-SoC-SUT](https://github.com/IObundle/iob-soc-sut) repository is just a subclass of IOb-SoC, that creates a derivation of that system which the tools required to specifically verify that System Under Test (SUT).

The Tester system is compatible with any Unit Under Tester (UUT) as it does not impose any hardware constraints.
For instructions on how to set up the Tester with a generic UUT, see [this section](https://github.com/IObundle/iob-soc-sut#instructions-to-configure-the-opencryptotester-with-a-generic-uut).

# Acknowledgement
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
