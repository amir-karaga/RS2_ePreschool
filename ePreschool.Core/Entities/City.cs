﻿using ePreschool.Core.Entities.Base;

namespace ePreschool.Core.Entities
{
    public class City:BaseEntity
    {
        public string Name { get; set; }
        public string Abrv { get; set; }
        public int? CountryId { get; set; }
        public Country Country { get; set; }
        public bool IsActive { get; set; }
    }
}
