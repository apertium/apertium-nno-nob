<?xml version="1.0" encoding="UTF-8"?>
<tagger name="Norwegian Bokmål">
  <tagset>
    <def-label name="NOMF">
      <tags-item tags="n.f.*"/>
    </def-label>
    <def-label name="NOMM">
      <tags-item tags="n.m.*"/>
    </def-label>
    <def-label name="NOMNT">
      <tags-item tags="n.nt.*"/>
    </def-label>
    <def-label name="NOMMF">
      <tags-item tags="n.mf.*"/>
    </def-label>
    <def-label name="NOMACR">
      <tags-item tags="n.acr"/>
    </def-label>

    <def-label name="PROPN">
      <tags-item tags="np"/>
      <tags-item tags="np.*"/>
    </def-label>

    <def-label name="NUM">
      <tags-item tags="num"/>
      <tags-item tags="num.*"/>
    </def-label>

    <def-label name="DET">
      <tags-item tags="det.*"/>
    </def-label>

    <def-label name="DETDEM">
      <tags-item tags="det.dem.*"/>
    </def-label>

    <def-label name="PRNPERS">
      <tags-item tags="prn.p1.*"/>
      <tags-item tags="prn.p2.*"/>
      <tags-item tags="prn.p3.*"/>
      <tags-item tags="prn.sg"/>
    </def-label>

    <def-label name="PRNITG">
      <tags-item tags="prn.itg"/>
    </def-label>

    <def-label name="PRNREFRES">
      <tags-item tags="prn.ref.*"/>
      <tags-item tags="prn.res.*"/>
    </def-label>

    <def-label name="PRNINGENNOE">
      <tags-item tags="prn.nt.*"/>
      <tags-item tags="prn.f.*"/>
      <tags-item tags="prn.m.*"/>
      <tags-item tags="prn.pl"/>
      <tags-item tags="prn.neg.*"/>
    </def-label>

    <def-label name="ADJ">
      <tags-item tags="adj.*"/>
    </def-label>

    <def-label name="ADV">
      <tags-item tags="adv"/>
    </def-label>

    <def-label name="IJ">
      <tags-item tags="ij"/>
    </def-label>

    <def-label name="PREP">
      <tags-item tags="pr"/>
    </def-label>

    <def-label name="CNJSUB">
      <tags-item tags="cnjsub"/>
    </def-label>

    <def-label name="CNJCOO">
      <tags-item tags="cnjcoo"/>
    </def-label>

    <def-label name="CNJCOOCLB">
      <tags-item tags="cnjcoo.clb"/>
    </def-label>

    <def-label name="VBSER">
      <tags-item tags="vbser.*"/>
    </def-label>

    <def-label name="VBLEX">
      <tags-item tags="vblex"/>   <!-- entries like this are probably broken -->
      <tags-item tags="vblex.*"/>
    </def-label>

    <def-label name="VBLEXINF">
      <tags-item tags="vblex.inf"/>
    </def-label>

    <def-label name="SENTCLB">
      <tags-item tags="sent.*"/>
    </def-label>

    <def-label name="CMCLB">
      <tags-item tags="cm.*"/>
    </def-label>

    <def-label name="apos">
      <tags-item tags="apos"/>
    </def-label>

    <!-- cmp+n, compounds: -->
    <def-mult name="CMP+NOMF">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMF"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+NOMM">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMM"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+NOMNT">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMNT"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+NOMMF">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMMF"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+NOMACR">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMACR"/>
      </sequence>
    </def-mult>

    <!-- cmp+cmp+n -->
    <def-mult name="CMP+CMP+NOMF">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMF"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+NOMM">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMM"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+NOMNT">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMNT"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+NOMMF">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMMF"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+NOMACR">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMACR"/>
      </sequence>
    </def-mult>

    <!-- cmp+cmp+cmp+n -->
    <def-mult name="CMP+CMP+CMP+NOMF">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMF"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+CMP+NOMM">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMM"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+CMP+NOMNT">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMNT"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+CMP+NOMMF">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMMF"/>
      </sequence>
    </def-mult>
    <def-mult name="CMP+CMP+CMP+NOMACR">
      <sequence>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <tags-item tags="n.*.cmp"/>
        <label-item label="NOMACR"/>
      </sequence>
    </def-mult>

  </tagset>

  <forbid>
    <label-sequence>
      <label-item label="CNJSUB"/>
      <label-item label="CNJSUB"/>
    </label-sequence>
  </forbid>

</tagger>

