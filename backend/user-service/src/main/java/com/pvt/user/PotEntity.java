package com.pvt.user;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;

@Entity
public class PotEntity {
    @Id
    @GeneratedValue
    private Long id;

    @Enumerated(EnumType.STRING)
    private PotTemplate template;

    private int placementId;

    @ManyToOne
    private User user;

}