using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Asn1;

namespace CrimsonRufus
{
    /* PA-PAC-OPTIONS ::= SEQUENCE {
        FluffyFlags
        -- Claims(0)
        -- Branch Aware(1)
        -- Forward to Full DC(2)
        -- Resource-based Constrained Delegation (3)
       }
    */

    public class PA_PAC_OPTIONS
    {
        public byte[] fluffyFlags { get; set; }
        public PA_PAC_OPTIONS(bool claims, bool branch, bool fullDC, bool rbcd)
        {
            fluffyFlags = new byte[4] { 0, 0, 0, 0 };
            if (claims) fluffyFlags[0] = (byte)(fluffyFlags[0] | 8);
            if (branch) fluffyFlags[0] = (byte)(fluffyFlags[0] | 4);
            if (fullDC) fluffyFlags[0] = (byte)(fluffyFlags[0] | 2);
            if (rbcd) fluffyFlags[0] = (byte)(fluffyFlags[0] | 1);
            fluffyFlags[0] = (byte)(fluffyFlags[0] * 0x10);
        }

        public AsnElt Encode()
        {
            List<AsnElt> allNodes = new List<AsnElt>();
            AsnElt fluffyFlagsAsn = AsnElt.MakeBitString(fluffyFlags);
            fluffyFlagsAsn = AsnElt.MakeImplicit(AsnElt.UNIVERSAL, AsnElt.BIT_STRING, fluffyFlagsAsn);
            AsnElt parent = AsnElt.MakeExplicit(0, fluffyFlagsAsn);
            allNodes.Add(parent);
            AsnElt seq = AsnElt.Make(AsnElt.SEQUENCE, allNodes.ToArray());
            return seq;
        }
    }
}
