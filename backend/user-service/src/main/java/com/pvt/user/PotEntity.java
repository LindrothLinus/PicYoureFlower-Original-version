package com.pvt.user;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class PotEntity {
    @Id
    @GeneratedValue
    private Long id;

    @Enumerated(EnumType.STRING)
    private PotTemplate template;

    private int placementId;
    private Long flowerId;
    private boolean placed = false;

    public boolean isPlaced() {
        return this.placed;
    }

    public boolean getPlaced() {
        return this.placed;
    }

    public void setPlaced(boolean placed) {
        this.placed = placed;
    }

    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User user;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public PotTemplate getTemplate() {
        return template;
    }

    public void setTemplate(PotTemplate template) {
        this.template = template;
    }

    public int getPlacementId() {
        return placementId;
    }

    public void setPlacementId(int placementId) {
        this.placementId = placementId;
    }

    public Long getFlowerId() {
        return flowerId;
    }

    public void setFlowerId(Long flowerId) {
        this.flowerId = flowerId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}