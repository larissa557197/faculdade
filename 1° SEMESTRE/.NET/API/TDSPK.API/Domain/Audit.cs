using TDSPK.API.Domain.Enums;

namespace TDSPK.API.Domain
{
    public class Audit
    {
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public StatusType Status { get; protected set; }
    }
}
