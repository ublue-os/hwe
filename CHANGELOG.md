# Changelog

## [1.2.0](https://github.com/ublue-os/hwe/compare/v1.1.0...v1.2.0) (2025-04-18)


### Features

* **asus:** add supergfctl ([#251](https://github.com/ublue-os/hwe/issues/251)) ([2fe54d1](https://github.com/ublue-os/hwe/commit/2fe54d1f3cde3758495872415d8fea4820563bd9))
* build initramfs for surface, asus and nvidia ([#258](https://github.com/ublue-os/hwe/issues/258)) ([1b2c042](https://github.com/ublue-os/hwe/commit/1b2c042ed3e70fdf5ca4886c408a54d82c9d5c4e))
* **ci:** enable Fedora 41 builds ([#289](https://github.com/ublue-os/hwe/issues/289)) ([47e360b](https://github.com/ublue-os/hwe/commit/47e360b7ff005764becb2b696aea043d2233e34d))
* swap to negativo17 as nvidia driver source ([#234](https://github.com/ublue-os/hwe/issues/234)) ([98b6f7f](https://github.com/ublue-os/hwe/commit/98b6f7f2b40e9440279a04a4af872f82f6470e51))
* Update Tags for F41 Release ([#293](https://github.com/ublue-os/hwe/issues/293)) ([3726dc0](https://github.com/ublue-os/hwe/commit/3726dc0e8193dd54cb220b1b827a0294d188dc32))
* Use cached kernel ([#265](https://github.com/ublue-os/hwe/issues/265)) ([2f63b20](https://github.com/ublue-os/hwe/commit/2f63b20163734a45c9491727d41affb1e6a08269))
* use negativo17 in lieu of rpmfusion ([#282](https://github.com/ublue-os/hwe/issues/282)) ([82fbc21](https://github.com/ublue-os/hwe/commit/82fbc211ff51ff204fb69e8f22efcd3528bbea39))


### Bug Fixes

* [#290](https://github.com/ublue-os/hwe/issues/290) ([3a56e7a](https://github.com/ublue-os/hwe/commit/3a56e7a2466c5e96321855ec49ef84e76e75ffe8))
* 257 - Surface Camera support ([#270](https://github.com/ublue-os/hwe/issues/270)) ([5be0d8d](https://github.com/ublue-os/hwe/commit/5be0d8d432b89fb7fd9acb7fe3bca2326b113739))
* adapt for new image naming convention in F42+ ([fae1903](https://github.com/ublue-os/hwe/commit/fae19036e54ed0aeb39bbe3e3e24881b6980609d))
* adjust build schedule based on adjustments to main (https://github.com/ublue-os/main/pull/589) ([#254](https://github.com/ublue-os/hwe/issues/254)) ([cf77151](https://github.com/ublue-os/hwe/commit/cf7715106b10587f741c6e4bd3391f608906e8b0))
* change nvidia package names to match negativo17 updates ([#264](https://github.com/ublue-os/hwe/issues/264)) ([f050686](https://github.com/ublue-os/hwe/commit/f050686e82c0d0ab4730ccc483a795dd1c85e290))
* **ci:** ensure use of negativo17-nvidia repo (not multimedia) ([#314](https://github.com/ublue-os/hwe/issues/314)) ([9d83d07](https://github.com/ublue-os/hwe/commit/9d83d07f39a99bf0fbd4fa85c684084771378ddc))
* **ci:** remove cliwrap ([b39098d](https://github.com/ublue-os/hwe/commit/b39098db5e043d5afdbf6bb288b91b233b7b78e1))
* Disable Asus for Fedora -1 ([#256](https://github.com/ublue-os/hwe/issues/256)) ([7b601f1](https://github.com/ublue-os/hwe/commit/7b601f1a1f4db4ffd8adb4c8987d8cb14089b2f3))
* Don't let dnf5 remove patched mesa ([b69207c](https://github.com/ublue-os/hwe/commit/b69207cacf900636fd5acaa43a48a9e80dc221f6))
* nvidia fixes ([#292](https://github.com/ublue-os/hwe/issues/292)) ([3a56e7a](https://github.com/ublue-os/hwe/commit/3a56e7a2466c5e96321855ec49ef84e76e75ffe8)), closes [#290](https://github.com/ublue-os/hwe/issues/290)
* nvidia kernel.conf reflects reality ([#286](https://github.com/ublue-os/hwe/issues/286)) ([527e668](https://github.com/ublue-os/hwe/commit/527e668dc443c5c725f83ad4d5e69284ece48e99)), closes [#284](https://github.com/ublue-os/hwe/issues/284)
* **nvidia:** Enable persistenced service, add extra option to use /var/tmp as the storage for temporary files. ([#263](https://github.com/ublue-os/hwe/issues/263)) ([4fe7c33](https://github.com/ublue-os/hwe/commit/4fe7c3370ab7361e60b73567591b333852fc9d7b))
* **nvidia:** pin Nvidia drivers to 555 ([#273](https://github.com/ublue-os/hwe/issues/273)) ([c0ffe44](https://github.com/ublue-os/hwe/commit/c0ffe44db571aa6cc8965136dc115fb1b2f0a6f6))
* Remove unneeded asus-firmware repo ([#311](https://github.com/ublue-os/hwe/issues/311)) ([0088ebb](https://github.com/ublue-os/hwe/commit/0088ebb9b93b2d691e1df26e5fe0d7e7e2b1d19d))
* set kernel_flavor and image_target matrix ([713e267](https://github.com/ublue-os/hwe/commit/713e267181196c16fe24aa46cb7ab9e4ad9748a1))

## [1.1.0](https://github.com/ublue-os/hwe/compare/v1.0.0...v1.1.0) (2024-04-27)


### Features

* Add 530xx series support and disable 525xx series support ([#81](https://github.com/ublue-os/hwe/issues/81)) ([b15964d](https://github.com/ublue-os/hwe/commit/b15964d63c519e4771eb9bbad5233ba965d45cbd))
* add supergfxctl package ([#77](https://github.com/ublue-os/hwe/issues/77)) ([20000b9](https://github.com/ublue-os/hwe/commit/20000b9aeab0ee5ad436ad394983dfb20baecb37))
* Add supergfxctl-plasmoid ([#118](https://github.com/ublue-os/hwe/issues/118)) ([029369f](https://github.com/ublue-os/hwe/commit/029369f836e170d7d8e15e52da1a4b03edce8a29))
* Break up build process into separate jobs to improve caching in matrix strategy ([#63](https://github.com/ublue-os/hwe/issues/63)) ([581f1fa](https://github.com/ublue-os/hwe/commit/581f1fa78f3ff59d3405e2ab79e98960fa3d3c1e))
* **ci:** Verify base image with cosign before building ([#184](https://github.com/ublue-os/hwe/issues/184)) ([d50d598](https://github.com/ublue-os/hwe/commit/d50d59816a2c7ca9434aa8cc498d27f8503f51a9))
* cut over nvidia akmod signing key ([#109](https://github.com/ublue-os/hwe/issues/109)) ([7a5bdce](https://github.com/ublue-os/hwe/commit/7a5bdce97ceca5205b671332d0cac3491c8ef4dd))
* download RPM metadata in build stage to lower bandwidth usage in final stage ([#65](https://github.com/ublue-os/hwe/issues/65)) ([95d9c13](https://github.com/ublue-os/hwe/commit/95d9c132c2f8908d7b5e4fcf7362219286502bb4))
* drop support for nvidia 470 ([#227](https://github.com/ublue-os/hwe/issues/227)) ([0275687](https://github.com/ublue-os/hwe/commit/027568799d306cb454a72ecffb62fde17a3cdd85))
* enable new nvidia-container-toolkit ([#159](https://github.com/ublue-os/hwe/issues/159)) ([0acde2f](https://github.com/ublue-os/hwe/commit/0acde2f31341370381f64a2b9529e1db03a09b11))
* Enable Nvidia driver builds for v535 ([#122](https://github.com/ublue-os/hwe/issues/122)) ([fc8c211](https://github.com/ublue-os/hwe/commit/fc8c2119da8331a1a3c532482c37e091511e89ac))
* Enable NVIDIA driver version 545 ([#165](https://github.com/ublue-os/hwe/issues/165)) ([2736f65](https://github.com/ublue-os/hwe/commit/2736f65ba9ec33c78f579851b7b80256af23539a))
* enable ublue-nvctk-cdi.service by default ([#162](https://github.com/ublue-os/hwe/issues/162)) ([19f6b36](https://github.com/ublue-os/hwe/commit/19f6b3677b2a41d356ed124b2c3cfb6dceb82eb5))
* Fedora 37 is EOL 2023-12-05 ([#176](https://github.com/ublue-os/hwe/issues/176)) ([427b625](https://github.com/ublue-os/hwe/commit/427b625808a767b4ecc2d6a92a4af71d688445cc))
* Generate image info ([#154](https://github.com/ublue-os/hwe/issues/154)) ([5717bd9](https://github.com/ublue-os/hwe/commit/5717bd9ee14c4d5990cb63d0ef62baa40c84a031))
* Make supergfxctl optional based on IMAGE_NAME ([#201](https://github.com/ublue-os/hwe/issues/201)) ([a8d340b](https://github.com/ublue-os/hwe/commit/a8d340bf62e30fdbd592b82b14b73e6516d16987))
* Mark Fedora 39 images as stable and roll out gts ([#163](https://github.com/ublue-os/hwe/issues/163)) ([76bc11f](https://github.com/ublue-os/hwe/commit/76bc11f234ba9f6e9e979d9c888a43663df857bf))
* promote Fedora 40 to latest and Fedora 39 to GTS ([#240](https://github.com/ublue-os/hwe/issues/240)) ([07bcfd7](https://github.com/ublue-os/hwe/commit/07bcfd72f5ab0167b9f218219a8501418f239171))
* **Silverblue:** Add supergfxctl-gex GNOME Shell extension ([#141](https://github.com/ublue-os/hwe/issues/141)) ([8f2bb09](https://github.com/ublue-os/hwe/commit/8f2bb095a40bfbce5857316bbbc364cfdffa0d7b))
* swap to negativo17 as nvidia driver source ([#231](https://github.com/ublue-os/hwe/issues/231)) ([ed30173](https://github.com/ublue-os/hwe/commit/ed301734d4c60d8cc1d15f7335af7505386eb93f))
* switch the latest tag to F38 ([#97](https://github.com/ublue-os/hwe/issues/97)) ([91aac1a](https://github.com/ublue-os/hwe/commit/91aac1ad00cb78e86edb3f284a5d224f0146e0ef))
* switch to akmods repo provided nvidia kmod ([#146](https://github.com/ublue-os/hwe/issues/146)) ([3bdde4c](https://github.com/ublue-os/hwe/commit/3bdde4cb32fb9c6965c81fad026c504454554691))
* turn on F39 for vauxite ([#164](https://github.com/ublue-os/hwe/issues/164)) ([e5f62a3](https://github.com/ublue-os/hwe/commit/e5f62a3e1e8cca1a5b822865f27e6c12ac350490))


### Bug Fixes

* add gitattributes file to fix linguist ([#203](https://github.com/ublue-os/hwe/issues/203)) ([079e8a6](https://github.com/ublue-os/hwe/commit/079e8a691d91b6c3d9b18a23f035229652546a62))
* add lazurite to build matrix ([#182](https://github.com/ublue-os/hwe/issues/182)) ([8bdefca](https://github.com/ublue-os/hwe/commit/8bdefcade0ce9b554a773d5f831146b8d174fb44))
* add signed image prep instructions ([#134](https://github.com/ublue-os/hwe/issues/134)) ([5758990](https://github.com/ublue-os/hwe/commit/5758990646e2880f1639fd28974c234b5a15d0bf))
* Added link from /usr/bin/rpm-ostree to /usr/bin/ dnf ([#117](https://github.com/ublue-os/hwe/issues/117)) ([9a28f47](https://github.com/ublue-os/hwe/commit/9a28f471e787b7adce4b32920b96cc84cdb9c40a))
* archive announcement. ([#147](https://github.com/ublue-os/hwe/issues/147)) ([7ccd678](https://github.com/ublue-os/hwe/commit/7ccd6787036a502ffec3da9dd695a5f4ea62c673))
* disable 520xx series due to broken compatibility in latest kernels ([#74](https://github.com/ublue-os/hwe/issues/74)) ([1f5306b](https://github.com/ublue-os/hwe/commit/1f5306bf30651aac2486dcce0e8785112bdb2f38))
* don't attempt to build os images for v530 ([#132](https://github.com/ublue-os/hwe/issues/132)) ([a200ee1](https://github.com/ublue-os/hwe/commit/a200ee17f416d317271d2eb138128c82cb03b2c9))
* Don't disable rpmfusion after installation ([#112](https://github.com/ublue-os/hwe/issues/112)) ([8405dc4](https://github.com/ublue-os/hwe/commit/8405dc42be847b4a75434725066715553fa13ee3))
* drop failing v530 driver build ([#131](https://github.com/ublue-os/hwe/issues/131)) ([3ed31f3](https://github.com/ublue-os/hwe/commit/3ed31f33e11bb4dd3a3cacf595346fed4aef6861))
* Ensure /tmp has right permissions set ([#67](https://github.com/ublue-os/hwe/issues/67)) ([d743ca0](https://github.com/ublue-os/hwe/commit/d743ca0a0afd3572e2af83c1d075398d17db9c33))
* image name and description variable interpolation ([#62](https://github.com/ublue-os/hwe/issues/62)) ([cf4e489](https://github.com/ublue-os/hwe/commit/cf4e489c60871cc1bcf3fcd0f797bfbe22bd5731))
* **image-info:** Correct image reference ([#155](https://github.com/ublue-os/hwe/issues/155)) ([a515d91](https://github.com/ublue-os/hwe/commit/a515d916002f9a0f9262b53f7bc4c9205b9b3bd7))
* install supergfxctl-plasmoid ([#121](https://github.com/ublue-os/hwe/issues/121)) ([1f6d6f2](https://github.com/ublue-os/hwe/commit/1f6d6f2da87912a2e716bc1f9084228c627c617a))
* maintain oci image version from upstream ([#76](https://github.com/ublue-os/hwe/issues/76)) ([f0537de](https://github.com/ublue-os/hwe/commit/f0537de2c808b6e12fdb3962e401bc34389aefa6))
* readme formatting ([#103](https://github.com/ublue-os/hwe/issues/103)) ([8748de0](https://github.com/ublue-os/hwe/commit/8748de008df00c9af097729542f85930b35ba95f))
* remove dangling `ld` symlink ([#189](https://github.com/ublue-os/hwe/issues/189)) ([24b3aca](https://github.com/ublue-os/hwe/commit/24b3acabf9f381b7a8164ab367e26578cf517ed4)), closes [#188](https://github.com/ublue-os/hwe/issues/188)
* remove lxqt 39 as lazurite replaced it ([#186](https://github.com/ublue-os/hwe/issues/186)) ([871e95c](https://github.com/ublue-os/hwe/commit/871e95c22dff52f3fbc607a1ee49b939014522c3))
* **supergfxctl:** Use new copr for continued Fedora 37 support ([#138](https://github.com/ublue-os/hwe/issues/138)) ([75627e1](https://github.com/ublue-os/hwe/commit/75627e140689404e6e3de18f2b86adb88dbe3529))
* temporary remove supergfxctl-plasmoid ([#120](https://github.com/ublue-os/hwe/issues/120)) ([5c716a8](https://github.com/ublue-os/hwe/commit/5c716a8178dd5a07970bcdf94302fd7d033c6824))
* update readme headers so we can deep link setup instructions ([#105](https://github.com/ublue-os/hwe/issues/105)) ([fb5263b](https://github.com/ublue-os/hwe/commit/fb5263b331827d8c51c8e6644a847b4a1c835f12))
* use new akmods:main-RELEASE tag structure ([#156](https://github.com/ublue-os/hwe/issues/156)) ([8572a23](https://github.com/ublue-os/hwe/commit/8572a23698b36b2fcdf28d87e980c3c9ec95cacc))
* use skopeo for more efficient upstream image introspection ([#79](https://github.com/ublue-os/hwe/issues/79)) ([9bdcd6e](https://github.com/ublue-os/hwe/commit/9bdcd6eff5b1cf0d5d8db3b69af6d7fabfce3e18))

## 1.0.0 (2023-03-07)


### Features

* add a vauxite build ([#32](https://github.com/ublue-os/nvidia/issues/32)) ([420740c](https://github.com/ublue-os/nvidia/commit/420740cebd61d3c4f727f8e5812bc7760b05869c))
* add code of conduct ([#16](https://github.com/ublue-os/nvidia/issues/16)) ([3bae6de](https://github.com/ublue-os/nvidia/commit/3bae6deda8428167370b820b84b94f571bcdea78))
* add dependabot to check actions ([#51](https://github.com/ublue-os/nvidia/issues/51)) ([290757f](https://github.com/ublue-os/nvidia/commit/290757f606881e0d64048d1b3cf7676c56500c15))
* Add devel branch to pull request process ([#23](https://github.com/ublue-os/nvidia/issues/23)) ([21cef45](https://github.com/ublue-os/nvidia/commit/21cef4521247eed7497b7d2bc3f43d26e07a8c7d))
* Add justfile support ([#58](https://github.com/ublue-os/nvidia/issues/58)) ([2870a5a](https://github.com/ublue-os/nvidia/commit/2870a5aaf154dd33ae1d8592dc2ad8a3e75a6021))
* Add Nvidia 470xx support ([#48](https://github.com/ublue-os/nvidia/issues/48)) ([6d4afbc](https://github.com/ublue-os/nvidia/commit/6d4afbc59dbc278065b7a1b483411b2dc39c347a))
* Add steam-devices package ([#50](https://github.com/ublue-os/nvidia/issues/50)) ([c9a544b](https://github.com/ublue-os/nvidia/commit/c9a544b6a165a349ca7d9953f8627bf01f361ca5))
* Add support for using nvidia GPUs inside containers ([#43](https://github.com/ublue-os/nvidia/issues/43)) ([303bf28](https://github.com/ublue-os/nvidia/commit/303bf28d71220264d979f01f7311c0abc7e9a0cc))
* Add vaapi packages to enable hardware-accelerated playback ([#44](https://github.com/ublue-os/nvidia/issues/44)) ([9f1b0a4](https://github.com/ublue-os/nvidia/commit/9f1b0a435655a2e252ccae55423f7a9a8749b475))
* create persistent secure boot test keys for easier downstream builds ([#45](https://github.com/ublue-os/nvidia/issues/45)) ([52a97ec](https://github.com/ublue-os/nvidia/commit/52a97ec21aa21c1b33bd7ce636857de78c3fa9e6))
* enable Fedora 38 builds ([#46](https://github.com/ublue-os/nvidia/issues/46)) ([23184fb](https://github.com/ublue-os/nvidia/commit/23184fb880521e243c1a906c7181bc7298050836))
* generate test keys for pull requests ([#34](https://github.com/ublue-os/nvidia/issues/34)) ([4254300](https://github.com/ublue-os/nvidia/commit/4254300a0032a1e08d98cd4cf97146d610597102))
* Improve sway session compatibility in Sericea image ([#49](https://github.com/ublue-os/nvidia/issues/49)) ([65f2a0a](https://github.com/ublue-os/nvidia/commit/65f2a0a2abe37ea2e63a23f39c060e4f67d60640))
* Improved image names & README Improvements ([#29](https://github.com/ublue-os/nvidia/issues/29)) ([#30](https://github.com/ublue-os/nvidia/issues/30)) ([f6686d1](https://github.com/ublue-os/nvidia/commit/f6686d1bd6215bd4195ba144c2137e68755dc24e))
* Refactor tagging to support multiple image and driver channels ([#36](https://github.com/ublue-os/nvidia/issues/36)) ([e21e60f](https://github.com/ublue-os/nvidia/commit/e21e60fc47b1b5618a18eb567b031007a0c6f6eb))
* split container build into distinct build script stages ([#59](https://github.com/ublue-os/nvidia/issues/59)) ([ca99377](https://github.com/ublue-os/nvidia/commit/ca9937787fd68291930c0a61d56bf254f52d3430))
* switch to upstream main image ([#54](https://github.com/ublue-os/nvidia/issues/54)) ([3a6a268](https://github.com/ublue-os/nvidia/commit/3a6a26853e8813439c38e05b5bd841db8821a9fc))
* Use variables more extensively in build workflow ([#55](https://github.com/ublue-os/nvidia/issues/55)) ([c9737c2](https://github.com/ublue-os/nvidia/commit/c9737c271e60679ff05050dcad4f60b30db8709f))


### Bug Fixes

* add cron delay to build ([#56](https://github.com/ublue-os/nvidia/issues/56)) ([0058346](https://github.com/ublue-os/nvidia/commit/0058346750096c225bbad537d3263b6bd7cbf345))
* Improve separation of tags between PR builds and normal builds ([#39](https://github.com/ublue-os/nvidia/issues/39)) ([18ae5e9](https://github.com/ublue-os/nvidia/commit/18ae5e951bde4024f0a8e02b4d424402962f8853))
* preserve /var/tmp for akmods builds ([#47](https://github.com/ublue-os/nvidia/issues/47)) ([48dd697](https://github.com/ublue-os/nvidia/commit/48dd697ff4cab166256603db34a43ccd13884f8f))
* Remove excess tags so none are dropped at end of build ([#37](https://github.com/ublue-os/nvidia/issues/37)) ([24be3ba](https://github.com/ublue-os/nvidia/commit/24be3ba6b005ea8229a8523b519a51acb64c103e))
* update cosign command and pin install ([#53](https://github.com/ublue-os/nvidia/issues/53)) ([431cb39](https://github.com/ublue-os/nvidia/commit/431cb395cdbf1384f31c80e6b62fe2906ffa5f6c))
* update readme-url ([#42](https://github.com/ublue-os/nvidia/issues/42)) ([4b1c5e6](https://github.com/ublue-os/nvidia/commit/4b1c5e6bc5285d82347881323885701899695cf3))
* use full image title and updated description for labels ([#40](https://github.com/ublue-os/nvidia/issues/40)) ([a11e214](https://github.com/ublue-os/nvidia/commit/a11e21496a60a51c2b89e5a5a8267fc30fd90f21))
